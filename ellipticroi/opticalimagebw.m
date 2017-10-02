function hh=oneimagebw(img)
if 1 
  img=floor(img);
  cc=sort(img(:)); C=length(cc);
  n0=cc(ceil(.01*C));
  n1=cc(ceil(.99995*C));
  img(img<n0)=n0;
  img(img>n1)=n1;
  [cc,xx]=hist(img(:),[n0:n1]);
  cc(1)=0;
  yy=cumsum(cc); yy=yy/yy(end);
  [Y X]=size(img);
  img = yy(img-n0+1).^1.5;
  hh=image(repmat(img,[1 1 3]));
else
  hh=imagesc(img);
  cc=sort(img(:)); C=length(cc);
  set(gca,'clim',[cc(ceil(.5*C)) cc(ceil(.995*C))]);
  colormap(gca,gray(256).^.5);
end
set(gca,'xtick',[]);
set(gca,'ytick',[]);
