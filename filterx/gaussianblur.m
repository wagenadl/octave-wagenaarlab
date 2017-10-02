function img=gaussianblur(img,rx,ry)
% img=GAUSSIANBLUR(img,rx,ry) performs a Gaussian blur on the image
% IMG (which must be a 2d-matrix of size YxX).
% If ry is not specified, it defaults to rx.

if nargin<3
  ry=rx;
end

bx=exp(-.5*[-4:(1/rx):4].^2); bx=bx/sum(bx);
by=exp(-.5*[-4:(1/ry):4].^2); by=by/sum(by);
ax=zeros(length(bx),1); ax(1)=1;
ay=zeros(length(by),1); ay(1)=1;
dx=floor(length(bx)/2);
dy=floor(length(by)/2);

[Y X]=size(img);
img=cat(1,img,zeros(length(by),X));
img=cat(2,img,zeros(Y+length(by),length(bx)));
img=filter(bx,ax,filter(by,ay,img)')';
img=img([1:Y]+dy,[1:X]+dx);
