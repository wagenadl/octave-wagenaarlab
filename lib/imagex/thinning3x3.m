function im1 = thinning3x3(im0, kern1, kern2)
im0 = 0+(im0>0);
im1 = im0 .* (1-hitmiss3x3(im0,kern1,kern2));
