function img=gaussianblur1d(img,rx)
% img=GAUSSIANBLUR1D(img,r) performs a Gaussian blur on a 1d "image"

if rx==0
  return
end

bx=exp(-.5*[-4:(1/rx):4].^2); bx=bx/sum(bx);
ax=zeros(length(bx),1); ax(1)=1;
dx=floor(length(bx)/2);
zz=zeros(length(bx),1);

xy = size(img);
flp=0;
if xy(1)==1
  img=img';
  flp=1;
end
[X D]=size(img);
for d=1:D
  im = cat(1,img(:,d),zz);
  im = filter(bx,ax,im);
  img(:,d) = im([1:X]+dx);
end
if flp
  img=img';
end
