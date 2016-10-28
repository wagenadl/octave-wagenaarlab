function gmi_quickalign(f, area, lcl)
global cd_data
if nargin<2
  A = max(cd_data{f}.can.area);
  for a=2:A
    gmi_quickalign(f, a, 0)
  end
  gmi_plotimage(f);
  return
end

cidx = find(cd_data{f}.can.area==area);
ifix = find(cd_data{f}.act.area==area & cd_data{f}.act.hasidx);
K = length(ifix);

imap = cd_data{f}.act.idx(ifix);
can.x = cd_data{f}.can.x(imap);
can.y = cd_data{f}.can.y(imap);
tgt.x = cd_data{f}.act.x(ifix);
tgt.y = cd_data{f}.act.y(ifix);

tgt.x = tgt.x(:);
tgt.y = tgt.y(:);
can.x = can.x(:);
can.y = can.y(:);

tx0 = 0;
ty0 = 0;

if K>=1
  tx0 = mean(tgt.x)
  ty0 = mean(tgt.y)
  tgt.x = tgt.x - tx0;
  tgt.y = tgt.y - ty0;
end

% We want a transformation s.t. the distance b/w (xx0,yy0) and (xtgt,ytgt)
% is minimized
xf = af_unity;
res = af_apply(xf, can);

if K>=1
  % Translate actuals to zero mean
  xf = af_translate(xf, -mean(can.x), -mean(can.y));
  res = af_apply(xf, can);
end

if K>=2
  xf = gmi_scaletomatch(xf, res, tgt);
  res = af_apply(xf, can);
  
  xf = gmi_rotatetomatch(xf, res, tgt);
  res = af_apply(xf, can);
end

if K>=3
  % We have an extra d.o.f., so we can scale x and y separately
  xf = gmi_scaletomatch(xf, res, tgt, 1);
  res = af_apply(xf, can);
  % I think we'd better rotate again
  xf = gmi_rotatetomatch(xf, res, tgt);
  res = af_apply(xf, can);
end

if K>=4
  % We could try to perspectivize
end

if K>=5
  % We could try to shear
end

% And now for some real magic: local shifts
if lcl && K>=2
  lclshift = struct;
  for k=1:K
    kk = [1:K];
    kk(k) = [];
    x0 = res.x(k);
    y0 = res.y(k);
    if isempty(kk)
      dd = 2*cd_data{f}.can.r(k).^2;
    else
      dd = min((res.x(kk)-x0).^2 + (res.y(kk)-y0).^2);
    end
    lclshift.dx(k) = tgt.x(k) - x0;
    lclshift.dy(k) = tgt.y(k) - y0;
    lclshift.x0(k) = x0;
    lclshift.y0(k) = y0;  
    lclshift.dd(k) = dd/3;
  end
end

% Apply to all, not just fixed points
can.x = cd_data{f}.can.x(cidx);
can.y = cd_data{f}.can.y(cidx);
res = af_apply(xf, can);

% Apply local shifts
if lcl && K>=2
  scl = zeros(length(can.x), K);
  for k=1:K
    scl(:,k) = exp(-.5*((res.x - lclshift.x0(k)).^2 ...
        + (res.y - lclshift.y0(k)).^2)...
        ./ lclshift.dd(k));
  end
  scl = scl ./ sum(scl, 2);
  for k=1:K
    res.x = res.x + scl(:,k).*lclshift.dx(k);
    res.y = res.y + scl(:,k).*lclshift.dy(k);
  end
  lclshift.scl = scl;
end

% Translate to canonical
res.x = res.x + tx0;
res.y = res.y + ty0;

cd_data{f}.cres.x(cidx) = res.x;
cd_data{f}.cres.y(cidx) = res.y;

ifreeze
gmi_plotimage(f);
for n = 1:length(cidx)
  iset(cd_data{f}.ht(cidx(n)), 'pos', [res.x(n) res.y(n)]);
end
iunfreeze
