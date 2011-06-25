function im1 = dilate3x3(im0, kernel)
im0=0+(im0>0);
kernel=0+(kernel>0);
if 1
  im1 = conv2(im0,kernel,'same');
else
L=size(kernel,1); L1=floor(L/2);
im0=0+(im0>0);
kernel=0+(kernel>0);
im1=zeros(size(im0));
for x=1:L
  for y=1:L
    bl = im0(y:end-L+y,x:end-L+x) .* kernel(L+1-y,L+1-x);
    im1(1+L1:end-L1,1+L1:end-L1) = im1(1+L1:end-L1,1+L1:end-L1) + bl;
  end
end
end
im1=0+(im1>0);
