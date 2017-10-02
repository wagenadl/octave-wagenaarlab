function im1=hitmiss3x3(im0, kern1, kern2)
im0=0+(im0>0);
im1 = erode3x3(im0,kern1) .* (1-erode3x3(im0,kern2));
