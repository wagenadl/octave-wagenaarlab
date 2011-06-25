function autowhitebalance(ifn,ofn,maskfn,graytarget)
% AUTOWHITEBALANCE(ifn,ofn) loads image IFN and automatically corrects
% its white balance saving the result into OFN.
% AUTOWHITEBALANCE(ifn,ofn,maskfn) uses only pixels from IFN that have
% value>=128 in MASKFN.


img = imread(ifn);
if nargin>2 & ~isempty(maskfn)
  mask=imread(maskfn);
else
  mask=uint8(zeros(size(img))+255);
end
if nargin<4
  graytarget=[];
end

mask=mean(mask,3);
[Y X C]=size(img);
img=reshape(img,[Y*X C]);
mask=reshape(mask,[Y*X 1]);
nominal_gray = img(mask>=128,:);
val = floor(mean(nominal_gray,2)+.5); % 0..255

avg_gray = zeros(256,3);
n_gray = zeros(256,1);
s=warning('off');
for v=0:255
  idx=find(val==v);
  avg_gray(v+1,:) = mean(nominal_gray(idx,:));
  n_gray(v+1) = length(idx);
end
warning(s);

corr = zeros(256,3);
idx=find(n_gray>0);
for c=1:3
  corr(:,c) = weighted_interp(idx+1,avg_gray(idx,c),[0:255]',n_gray(idx),32);
end

img=double(img);
val = floor(mean(img,2)+.5);
for v=0:255
  idx = find(val==v);
  N=length(idx);
  if N>0
    img(idx,:) = v .* img(idx,:) ./ repmat(corr(v+1,:),[N 1]);
  end
end


img = img/256; % Normalize to 0..1
img(img<0)=0; img(img>.999)=.999;
img = reshape(img,[Y X C]);

if ~isempty(graytarget)
  gamma = autogamma(val/256,graytarget);
  img = img.^gamma;
end

img = uint8(256*img);
if ~isempty(strfind(ofn,'jpg'))
  imwrite(img,ofn,'jpeg','quality',99);
else
  imwrite(img,ofn);
end

