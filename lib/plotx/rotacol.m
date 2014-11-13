function rgb = rotacol(rgb,theta)
% ROTACOL  Rotate the hue of a colormap
%   rgb = ROTACOL(rgb,theta) rotates the colormap RGB by THETA radians
%   in hue.
%   RGB may be XxC, or XxYxC.

[X Y C]=size(rgb);
if C==1
  rgb=reshape(rgb,[X 1 Y]);
end

hsv=rgb2hsv(rgb);

hsv(:,:,1)=mod(hsv(:,:,1)+theta/(2*pi),1);

rgb=hsv2rgb(hsv);

if C==1
  rgb=reshape(rgb,[X Y]);
end
