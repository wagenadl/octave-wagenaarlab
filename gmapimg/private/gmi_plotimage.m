function gmi_plotimage(f)
global cd_data
img0 = cd_data{f}.img;
[Y X] = size(img0);

if cd_data{f}.avis
  if cd_data{f}.area==1
    iact = gmi_roiimg(cd_data{f}.act, X, Y);
    imgR = img0.*(1-iact) + (img0*1.2+0.2).*iact;
    imgB = img0.*(1-0.2*iact);
  else
    iact1 = gmi_roiimg(subset(cd_data{f}.act, ...
        cd_data{f}.act.area==cd_data{f}.area), X, Y);
    iact0 = gmi_roiimg(subset(cd_data{f}.act, ...
        cd_data{f}.act.area~=cd_data{f}.area), X, Y);
    imgR = img0.*(1-iact1-iact0) + (img0*1.3+0.25).*iact1 ...
        + (img0*1.1+0.1).*iact0;
    imgB = img0.*(1-0.7*iact1-0.1*iact0);
  end
else
  imgR = img0;
  imgB = img0;
end

if cd_data{f}.cvis
  if cd_data{f}.area==1
    ican = gmi_roiimg(cd_data{f}.cres, X, Y);
    imgB = imgB.*(1-ican) + (imgB*.5+.5).*ican;
    imgR = imgR.*(1-.7*ican);
  else
    ican1 = gmi_roiimg(subset(cd_data{f}.cres, ...
        cd_data{f}.can.area==cd_data{f}.area), X, Y);
    ican0 = gmi_roiimg(subset(cd_data{f}.cres, ...
        cd_data{f}.can.area~=cd_data{f}.area), X, Y);
    imgB = imgB.*(1-ican1-ican0) + (imgB*.5+.5).*ican1 ...
        + (imgB.*.8+.2).*ican0;
    imgR = imgR.*(1-.7*ican1-.2*ican0);
  end
else
  imgB = img0;
end

if ~isfield(cd_data{f}, 'h_img')
  cd_data{f}.h_img = iimage(zeros(Y,X,3));
end

imgR = flipud(imgR);
imgB = flipud(imgB);

iset(cd_data{f}.h_img, 'cdata', cat(3, imgR, imgR, imgB));

