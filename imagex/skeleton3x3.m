function im1=skeleton3x3(im0,b1,b2)
im1=thinning3x3(im0,b1,b2);
while max(im1(:))>0
  im0=im1;
  im1=thinning3x3(im0,b1,b2);
end
im1=im0;