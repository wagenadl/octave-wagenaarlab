function img = gmi_loadimg(fn)
flipx = 0;
flipy = 0;
rot = 0;
if iscell(fn)
  if numel(fn)==4
    flipx = fn{2};
    flipy = fn{3};
    rot = fn{4};
    fn = fn{1};
  else
    error('gmi_loadimg can take either a filename or {file,flipx,flipy,rot}');
  end
end

img = imread(fn);

img = double(img);
if length(size(img))>=3
  img = mean(img, 3); % drop color info
end
img = img./max(img(:));

if flipx
  img = fliplr(img);
end

if flipy
  img = flipud(img);
end

switch rot
  case 90
    img = img';
    img = flipud(img);
  case 180
    img = flipud(img);
    img = fliplr(img);
  case 270
    img = flipud(img);
    img = img';
  case 0
    ;
  otherwise
    error('gmi_loadimg can rotate in increments of 90⁰ only');
end
