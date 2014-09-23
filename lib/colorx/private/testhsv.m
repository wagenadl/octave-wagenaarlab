N = 60;
on = ones(N, 1);
of = zeros(N, 1);
up = .75*(.5-.5*cos([.5:N]'/N * pi)) + .25*([.5:N]'/N);
dn = flipud(up);
rgb0 = [on up of; dn on of; of on up; of dn on; up of on; on of dn];

L = length(rgb0);

spc = 'cielch';

lab0 = colorconvert(rgb0, 'from', 'srgb', 'to', spc);

dch = diff(lab0(:,3));
dch = cumsum([0; dch<-3]);
lab0(:,3) = lab0(:,3) + 2*pi*dch;

dst=zeros(L-1,1);
for k=1:L-1
  %dst(k) = cielabdist(lab0(k,:), lab0(k+1,:));
  dst(k) = cielchdist(lab0(k,:), lab0(k+1,:));
  %  dst(k) = sqrt(sum((lab0(k,:) - lab0(k+1,:)).^2));
end
ii = [];
for k = 1 : L-1
  ii = [ii; k + [0:.05./dst(k):.9999]'];
  %ii = [ii; k + [0:.05:.9999]'];
end

lab = interp1([1:L]', lab0, ii, 'linear');
%lab = lab0;
N = length(lab);
lab = reshape(lab, [1 N 3]);
lab = repmat(lab, [100 1 1]);
laba = colorconvert([.5 .5 .5], 'from', 'srgb', 'to', spc);
for n=1:100
  lab(n, :, 1) = (n/100) * lab(n, :, 1) + (1-(n/100)) * laba(1);
  lab(n, :, 2) = (n/100) * lab(n, :, 2) + (1-(n/100)) * laba(2);
 %lab(n, :, 3) = (n/100) * lab(n, :, 3) + (1-(n/100)) * laba(3);
end

rgb = colorconvert(lab, 'from', spc, 'to', 'srgb', 'clip', 2);

qfigure('/tmp/foo');
qimage(rgb);
