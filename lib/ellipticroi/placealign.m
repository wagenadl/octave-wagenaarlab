function imout = placealign(images,shft,siz)
% images = PLACEALIGN(images,shft) returns a shifted stack of images, 
% cropped to overlap area.
% images = PLACAALIGN(images,shft,[Y X]) pads using median gray of each image.
%
% Typical use:
%
%   shft = bestalign(optical_data(:,1:254,:),10);
%   optical_data = placealign(optical_data(:,1:254,:),shft,[256 256]);
%
% or:
%
%  [Y X N] = size(ox_frames);
%  od = cat(3,ox_frames(:,1:254,:),cc2_frames(:,1:254,:));
%  shft = bestalign(od,10);
%  od = placealign(od,shft,[256 256]);
%  ox_frames = od(:,:,1:N);
%  cc2_frames = od(:,:,N+1:end);

if nargin<3
  siz=[];
end

[Y X N] = size(images);
keepy = [1+max(shft(1,:)):Y+min(shft(1,:))];
keepx = [1+max(shft(2,:)):X+min(shft(2,:))];

Y = length(keepy); X=length(keepx);
if isempty(siz)
  siz = [Y X];
end
plcy = floor((siz(1)-Y)/2) + [1:Y];
plcx = floor((siz(2)-X)/2) + [1:X];

imout = repmat(images(1,1,1),[siz(1) siz(2) N]);
for n=1:N
  med = median(reshape(images(keepy-shft(1,n),keepx-shft(2,n),n),[1 Y*X]));
  imout(:,:,n) = med;
  imout(plcy,plcx,n) = images(keepy-shft(1,n),keepx-shft(2,n),n);
end
