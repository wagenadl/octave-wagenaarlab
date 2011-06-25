function makeshift(ifn,ofn,super)
% MAKESHIFT(ifn,ofn) creates a shift map from a stack of images.
% MAKESHIFT(ifn,ofn,super) supersamples by a factor SUPER first.

if nargin<3
  super=1;
end

fprintf(1,'MAKESHIFT: Loading %s...\n',ifn);
x=load(ifn,'-mat');
opt=subtractdark(x.optical_data,x.dark_frame_avg);
fr1 = mean(double(opt(:,1:254,1:2:end)),3);
fr2 = mean(double(opt(:,1:254,2:2:end)),3);

if super>1
  fprintf(1,'  Rescaling...\n',ifn);
  [Y X] = size(fr1);
  [xx,yy] = meshgrid([1:.5:X],[1:.5:Y]);
  fr1 = interp2([1:X],[1:Y],fr1,xx,yy,'*linear');
  fr2 = interp2([1:X],[1:Y],fr2,xx,yy,'*linear');
end

fprintf(1,'  Shifting...\n');
[xshift, yshift] = getshift(fr1,fr2);

save(ofn,'xshift','yshift','-mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Show results

fprintf(1,'  Applying results...\n');
shf = useshift(x,ofn);
[Y X N] = size(shf);
fr1s = mean(double(shf(:,1:ceil(X*254/256),1:2:end)),3);
fr2s = mean(double(shf(:,1:ceil(X*254/256),2:2:end)),3);
if super>1
  fprintf(1,'  Scaling...\n');
  [Y X] = size(fr1s);
  [xx,yy] = meshgrid([1:.5:X],[1:.5:Y]);
  fr1s = interp2([1:X],[1:Y],fr1s,xx,yy,'*linear');
  fr2s = interp2([1:X],[1:Y],fr2s,xx,yy,'*linear');
end

fprintf(1,'  Displaying...\n');
figure(1); clf
xywh=get(0,'screensize');
set(gcf,'position',[xywh(3)-20-1024,xywh(4)-80-512,1024,512]);

aa=axes('position',[0 0 .5 1]);
[f1_,f1__] = nearminmax(fr1(:),.01,.01);
[f2_,f2__] = nearminmax(fr2(:),.01,.01);
img = cat(3,(fr1-f1_)/(f1__-f1_),(fr2-f2_)/(f2__-f2_),0*fr1);
img(img<0)=0; img(img>1)=1;
image(img);
set(gca,'xtick',[]); set(gca,'ytick',[]);
t = text(128,32,'Original','color','c','horizontala','center','fontsi',12);

as=axes('position',[.5 0 .5 1]);
[f1_,f1__] = nearminmax(fr1s(:),.01,.01);
[f2_,f2__] = nearminmax(fr2s(:),.01,.01);
img=cat(3,(fr1s-f1_)/(f1__-f1_),(fr2s-f2_)/(f2__-f2_),0*fr1s);
img(img<0)=0; img(img>1)=1;
image(img);
set(gca,'xtick',[]); set(gca,'ytick',[]);
t = text(128,32,'Shifted','color','c','horizontala','center','fontsi',12);
