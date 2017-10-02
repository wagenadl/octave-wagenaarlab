function cc = djet(N)
% DJET - Like JET, but better sampling of color space, especially for small N
%    cc = DJET(n) returns a JET color map with N entries.
%    cc = DJET returns a colormap with 256 entries.

if nargin<1
  N = 256;
end
if N==1
  phi = 0;
else
  phi=[0:N-1]'/(N-1);
end

B0 = .2;
G0 = .5;
R0 = .8;
SB = .2;
SG = .25;
SR = .2;
P=4;

blue = exp(-.5*(phi-B0).^P./SB.^P);
red = exp(-.5*(phi-R0).^P./SR.^P);
green = exp(-.5*(phi-G0).^P./SG.^P);

cc = [red green blue];

%cc = jet(100*N-99);
%cc = cc(1:100:end,:);
