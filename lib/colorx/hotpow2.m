function cc=hotpow2(n,p)
% cc=HOTPOW(n,p) returns a resampled HOT colormap of n elements
% indexing by i^p. This is a useful colormap for screen display.

if nargin<2
  p=.5;
end

if nargin<1
  n=64;
end

cc=hot(10001);
cc=interp1([0:10000]/10000,cc,([0:n-1]/(n-1)).^p,'linear');
