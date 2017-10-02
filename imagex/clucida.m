function [img, imgs] = clucida(imgs, fnos)
% CLUCIDA - Pseudo camera lucida image from image stack
%    img = CLUCIDA(imgs) takes an image stack and calculates contrast maps
%    for each image. It then flattens the stack using the local contrast
%    as a weight for each pixel.
%    img = CLUCIDA(idir, tri) loads snapshots using VSCOPE_LOAD. In that case,
%    [img, imgs] = CLUCIDA(...) returns the image stack as well.
%
%    Without arguments, runs an example

if nargin==0
  imgs = cl_loadeg('/da1/dw/vscope/110516',1:36,[50 350],[150 500]);
elseif nargin==2
  dir = imgs;
  Z = length(fnos);
  for z=1:Z
    x = vscope_load({dir, fnos(z)},'c');
    x = x.ccd.dat(:,:,1,1);
    [Y X] = size(x);
    if z==1
      imgs = zeros(Y,X,Z);
    end
    imgs(:,:,z) = x;
  end
end

[Y X Z] = size(imgs);

edg = { ...
    [1 1 0; 1 0 -1; 0 -1 -1], ...
    [0 1 1; -1 0 1; -1 -1 0], ...
    [1 1 1; 0 0 0; -1 -1 -1], ...
    [1 0 -1; 1 0 -1; 1 0 -1] ...
    };
lin = { ...
    [-1 -1 -1; 2 2 2; -1 -1 -1], ...
    [-1 2 -1; -1 2 -1; -1 2 -1], ...
    [-1 -1 2; -1 2 -1; 2 -1 -1], ...
    [2 -1 -1; -1 2 -1; -1 -1 2] ...
    };
dot = { ...
    [-1 -1 -1; -1 8 -1; -1 -1 -1] ...
    };
w0 = -10/12;
wln = { ... 
    [-1 -1 -1 -1 -1; 0 0 0 0 0; 2 2 2 2 2; 0 0 0 0 0; -1 -1 -1 -1 -1], ...
    [-1 0 2 0 -1; -1 0 2 0 -1; -1 0 2 0 -1; -1 0 2 0 -1; -1 0 2 0 -1], ...
    [w0 w0 w0 0 2; w0 w0 0 2 0; w0 0 2 0 w0; 0 2 0 w0 w0; 2 0 w0 w0 w0], ...
    [2 0 w0 w0 w0; 0 2 0 w0 w0; w0 0 2 0 w0; w0 w0 0 2 0; w0 w0 w0 0 2] };
    

emap = zeros(Y,X,Z,4);
for k=1:4
  for z=1:Z
    emap(:,:,z,k) = conv2(imgs(:,:,z),edg{k},'same');
  end
end
em = sum(emap.^2,4);

lmap = zeros(Y,X,Z,4);
for k=1:4
  for z=1:Z
    lmap(:,:,z,k) = conv2(imgs(:,:,z),lin{k},'same');
  end
end
lmap(lmap<0)=0;
lm = sum(lmap.^2,4);

wmap = zeros(Y,X,Z,4);
for k=1:4
  for z=1:Z
    wmap(:,:,z,k) = conv2(imgs(:,:,z),wln{k},'same');
  end
end
wmap(wmap<0)=0;
lm2 = sum(wmap.^2,4);

dmap = zeros(Y,X,Z,1);
for k=1
  for z=1:Z
    dmap(:,:,z,k) = conv2(imgs(:,:,z),dot{k},'same');
  end
end
dmap(dmap<0)=0;
dm = sum(dmap.^2,4);

drpy=[1 2 3 Y-2 Y-1 Y];
drpx=[1 2 3 X-2 X-1 X];

em(drpy,:,:)=0; em(:,drpx,:)=0;
lm(drpy,:,:)=0; lm(:,drpx,:)=0;
lm2(drpy,:,:)=0; lm2(:,drpx,:)=0;
dm(drpy,:,:)=0; dm(:,drpx,:)=0;
cm = (1*em+10*lm + 0*dm + 2*lm2); % These weights are rather arbitrary
im = imgs;
[b,a] = butterlow1(.1);

for z=1:Z
  for x=1:X
    cm(:,x,z) = filtfilt(b,a,cm(:,x,z));
    %im(:,x,z) = filtfilt(b,a,im(:,x,z));
  end
  for y=1:Y
    cm(y,:,z) = filtfilt(b,a,cm(y,:,z));
    %im(y,:,z) = filtfilt(b,a,im(y,:,z));
  end
end

wm = cm.^3;%./im;

%[mx,z] = max(wm,[],3);
%img=zeros(Y,X);
%for k=1:Z
%  w = wm(:,:,k);
%  w(w<mx)=0;
%  wm(:,:,k) = w;
%end
img = sum(imgs.*wm,3) ./ sum(wm,3);

if nargout==0
  imagesc(img);
end

if nargout<2
  clear imgs
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function imgs = cl_loadeg(idir, tri, xrng, yrng)

Z=length(tri);
for k=1:Z
  x = vscope_load({idir, tri(k)});
  x = x.ccd.dat(yrng(1):yrng(end),xrng(1):xrng(end));
  [Y X] = size(x);
  if k==1
    imgs = zeros(Y,X,Z);
  end
  imgs(:,:,k) = x;
end
