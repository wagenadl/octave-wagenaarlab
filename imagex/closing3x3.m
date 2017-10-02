function im1=closing3x3(im0, kernel)
im1 = erode3x3(dilate3x3(im0,kernel),kernel);
