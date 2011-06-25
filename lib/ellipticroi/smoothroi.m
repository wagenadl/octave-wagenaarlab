function rd = smoothroi(xyrra, imgs, varargin)
% SMOOTHROI - Extract pixel stats from elliptic ROIs
%   rd = SMOOTHROI(xyrra,imgs) extracts pixels stats from one or more 
%   elliptic ROIs from one or more images.
%   XYRRA must be 5xN; IMGS must be YxXxT.
%   SMOOTHROI(xyrra,imgs, key1,val1, ...) specifies additional parameters.
%   Parameters (with defaults) are:
%
%     r (1) - Smoothing radius, in pixels.
%     v (0) - Verbosity
%
%   Output is a structure with fields:
%
%     avg (NxT) - mean pixel value in ROI
%     sem (NxT) - sem of pixel value in ROI
%     npix (Nx1) - number of pixels in ROI
% 
%   Note: npix will not be integer, because edge pixels are counted partially.
%
%   Unlike EXTRACTELLIPTICROIS, this function will not exclude pixels from
%   lower numbered ROIs when extracting higher numbered ROIs.

args=getopt('r=1 v=0',varargin);
[five,N] = size(xyrra);
[Y,X,T] = size(imgs);

if five~=5
  error('smoothroi: xyrra must be 5xN');
end

rd.avg = zeros(N,T);
rd.std = zeros(N,T);
rd.npix = zeros(N,1);

xx = repmat([1:X],[Y 1]);
yy = repmat([1:Y]',[1 X]);

imgs = reshape(imgs,[Y*X T]);

for n=1:N
  if args.v
    fprintf(1,'smoothroi: %i/%i...    \r',n,N);
  end
  rad0 = sqrt(xyrra(3,n)^2 + xyrra(4,n)^2);
  bigrad = rad0 + args.r;
  idx0 = find(xx>xyrra(1,n)-bigrad & xx<xyrra(1,n)+bigrad & ...
      yy>xyrra(2,n)-bigrad & yy<xyrra(2,n)+bigrad);
  x_ = xx(idx0)-xyrra(1,n);
  y_ = yy(idx0)-xyrra(2,n);
  xi =  x_*cos(xyrra(5,n))+y_*sin(xyrra(5,n));
  eta = -x_*sin(xyrra(5,n))+y_*cos(xyrra(5,n));
  
  rad = rad0/sqrt(2);
  
  normdist2 = (xi/xyrra(3,n)).^2 + (eta/xyrra(4,n)).^2;
  
  % I want to calculate cut = normdist-1, and I only care for accuracy near
  % normdist=1, the cut-off point. Noting that
  % 
  %   normdist^2 - 1 = (normdist - 1) (normdist + 1) ~= 2 (normdist - 1)
  %
  % I can write:
  
  cut = (normdist2-1)/2;
  wei = .5-.5*tanh(cut*rad/args.r);
  sm1 = sum(wei);
  for t=1:T
    smx = sum(wei.*imgs(idx0,t));
    rd.avg(n,t) = smx/sm1;
    smxx = sum(wei.*(imgs(idx0,t)-rd.avg(n,t)).^2);
    rd.sem(n,t) = sqrt(smxx/(sm1*(sm1-1)));
  end
  rd.npix(n) = sm1;
end
if args.v
  fprintf(1,'\n');
end