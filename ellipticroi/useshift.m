function imgs = useshift(img,shft)
% imgs = USESHIFT(ifn_img, ifn_shift) loads the file IFN_IMG as a '.iaq',
% and applies the shift from file IFN_SHIFT, which must be the result of
% MAKESHIFT.
% imgs = USESHIFT(str_img, str_shift) does the same using structures loaded
% from such files.
% If the shift structure was created using supersampling, useshift 
% automatically supersamples also.

if ~isstruct(img)
  img = load(img,'-mat');
end

if ~isstruct(shft) & ~isempty(shft)
  shft = load(shft,'-mat');
end

opt=subtractdark(img.optical_data,img.dark_frame_avg);
opt = opt(:,1:254,:);

if isempty(shft)
  imgs = double(opt);
else
  [Y X C] = size(opt);
  [Y_ X_] = size(shft.xshift);
  if Y_>Y
    imgs = zeros(Y_,X_,C);
    super = ceil(Y_/Y);
    [xx,yy] = meshgrid([1:1/super:X],[1:1/super:Y]);
    for c=1:C
      imgs(:,:,c) = interp2([1:X],[1:Y],double(opt(:,:,c)),xx,yy,'linear');
    end
  else
    imgs = double(opt);
  end
  
  imgs(:,:,1:2:end) = applyshift(imgs(:,:,1:2:end),shft.xshift/2,shft.yshift/2);
  imgs(:,:,2:2:end) = applyshift(imgs(:,:,2:2:end),-shft.xshift/2,-shft.yshift/2);
end
