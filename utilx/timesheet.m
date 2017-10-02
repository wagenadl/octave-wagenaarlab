timesheet1;

clr = [
  1 0 0; 
  0 1 0;
  0 0 1;
  .6 0 0;
  0 .6 0;
  0 0 .6;
  1 .5 .5;
  .5 1 .5;
  .5 .5 1;
  1 1 0;
  0 1 1;
  1 0 1;
  .7 .7 0;
  .8 .8 .8;
  1 1 1];
K=14;
K0=13; % w/o lunch
W=length(week)+1;
X=floor(sqrt(W));
Y=ceil(W/X);
for w=1:W
  x=div(w-1,Y);
  y=mod(w-1,Y);
  subplot(Y,X,x+1+X*y);
  if w==W
    qq=zeros(7,K);
    qq(4,:)=1;
    h=bar(qq,'stacked');
    set(gca,'xtick',[],'ytick',[]);
    for k=1:K
      if mod(k,2)==1
	text(3.5,k-.7,lgd{k},'horizontala','right');
      else
	text(4.5,k-.7,lgd{k},'horizontala','left');
      end
    end
	
  else
    h=bar(week{w}(:,1:K)/60,'stacked');
  set(gca,'xtick',[1:7],'xtickl',strtoks('Mon Tue Wed Thu Fri Sat Sun'));
  title(sprintf('Week of %s: %.1f hours',...
      weekttl{w},sum(sum(week{w}(:,1:K0)))/60));
  axis([.5 7.5 0 8.5]);
  end
  for k=1:K
    set(h(k),'facec',clr(k,:));
  end
end
