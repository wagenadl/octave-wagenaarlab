function im1=opening3x3(im0, kernel)
im1 = dilate3x3(erode3x3(im0,kernel),kernel);
