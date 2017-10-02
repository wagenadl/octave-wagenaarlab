function cc = dhsv(N)
% DHSV - Alternative HSV colormap with better perceptual uniformity
%    cc = DHSV(N) returns a more perceptually uniform cyclic colormap
%    with N entries. (N defaults to 64).
if nargin==0
  N = 64;
end

on = ones(N, 1);
of = zeros(N, 1);
up = .5*(.5-.5*cos([.5:N]'/N * pi)) + .5*([.5:N]'/N);
dn = flipud(up);
rgb0 = [on up of; dn on of; of on up; of dn on; up of on; on of dn];


l0=[0:(length(rgb0)-1)]*360/(length(rgb0)-1);
ll = l0;
ll = adjusthue(ll, 320, 30, -0.8);
rgb0 = interp1(l0, rgb0, ll);
ll = adjusthue(ll, 240, 60, 0.45);
rgb0 = interp1(l0, rgb0, ll);
ll = adjusthue(ll, 245, 25, 0.35);
rgb0 = interp1(l0, rgb0, ll);
ll = mod(adjusthue(mod(ll-180, 360), 180, 30, 0.65), 360);
rgb0 = interp1(l0, rgb0, ll);

rgb0 = interp1(l0, rgb0, [.5:N]*360/N);

cc = colorconvert(rgb0, 'from', 'linearrgb', 'to', 'srgb', 'clip', 1);
