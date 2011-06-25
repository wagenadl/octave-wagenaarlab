function deint(ifnbase,ofnbase,imgno)
% DEINT - Deinterlace an image or series of images
%    DEINT(ifnbase,ofnbase,imgnos)

if nargin>=3
  N=length(imgno);
  k=1;
  for n=1:N
    deint_core(sprintf(ifnbase,imgno(n)), ...
	sprintf(ofnbase,k), sprintf(ofnbase,k+1));
    k=k+2;
  end
else
  deint_core(ifnbase, ...
      sprintf(ofnbase,1), sprintf(ofnbase,2));
end
  
function deint_core(ifn, ofn1, ofn2)
img = imread(ifn);
iif = imfinfo(ifn);
[Y X C]=size(img); 
Y = 2*floor(Y/2);
im1 = img; im1(2:2:Y,:,:) = im1(1:2:Y,:,:);
im2 = img; im2(1:2:Y,:,:) = im2(2:2:Y,:,:);
if isfield(iif,'Colormap') & ~isempty(iif.Colormap)
  imwrite(im1,iif.Colormap,ofn1);
  imwrite(im2,iif.Colormap,ofn2);
else
  imwrite(im1,ofn1);
  imwrite(im2,ofn2);
end