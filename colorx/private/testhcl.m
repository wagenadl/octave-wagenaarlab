N = 80;
on = ones(N, 1);
of = zeros(N, 1);
up = .5*(.5-.5*cos([.5:N]'/N * pi)) + .5*([.5:N]'/N);
dn = flipud(up);
rgb0 = [on up of; dn on of; of on up; of dn on; up of on; on of dn];

l0=[0:(length(rgb0)-1)]*360/(length(rgb0)-1);
ll = l0;
ll = adjusthue(ll, 320, 30, -0.4);
rgb0 = interp1(l0, rgb0, ll);
ll = adjusthue(ll, 240, 60, 0.4);
rgb0 = interp1(l0, rgb0, ll);
ll = adjusthue(ll, 245, 25, .2);
rgb0 = interp1(l0, rgb0, ll);



%lab0 = linearrgbtohcl(rgb0);
%dch = diff(lab0(:,1));
%dch = cumsum([0; dch<-3]);
%lab0(:,1) = lab0(:,1) + 2*pi*dch;
%dp = diff(lab0(:,1));
%
%ii = [];
%for k = 1 : L-1
%  ii = [ii; k + [0:.02./dp(k):.9999]'];
%end
%
%lab = interp1([1:L]', lab0, ii, 'linear');
%%lab = lab0;
%N = length(lab);
%lab = reshape(lab, [1 N 3]);
%lab = repmat(lab, [10 1 1]);
%
%rgb = hcltolinearrgb(lab);


rgb = reshape(rgb0,[1 length(rgb0) 3]);
rgb = repmat(rgb, [100 1 1]);
for n=1:100
  a = n/100;
  a = a^1.5;
  b = 1 - a;
  rgb(n, :, :) = b*.5 + a*rgb(n, :, :);
end
rgb = colorconvert(rgb, 'from', 'linearrgb', 'to', 'srgb', 'clip', 1);

qfigure('/tmp/foo');
qimage(rgb);
