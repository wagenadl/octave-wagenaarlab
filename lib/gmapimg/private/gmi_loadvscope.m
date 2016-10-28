function str = gmi_loadvscope(ifn, dv)

% Will load data from vscope
if strcmp(dv, 'dorsal')
  %% Get canonicals
  can = mtc_dorsal(1);
  can.area = 2 + 2*(can.x>0) + (can.y<0.35 - 0.2*can.x.^2);
  arealabel = { 'All', 'Left ant', 'Left post', 'Right ant', 'Right post' };
elseif strcmp(dv, 'ventral')
  can = mtc_ventral(1);
  arealabel = { 'All', 'Left ant', 'Left post', ...
      'Right ant', 'Right post', ... 
      'Central', 'Posterior' };
  can.area = cd_ventralarea(can);
else
  error('Must specifiy dorsal or ventral');
end

% Load data from vscope
xdat = vscope_load(ifn);

% Get actual ROIs
act = gmi_getrois(xdat);
cam = gmi_guesscamera(act, dv)
act = subset(act, act.cam==cam);

[~, act.norm] = mtc_normalizecoords(act);

N = length(act.r);
act.id = cell(N,1);
for n=1:N
  act.id{n} = '';
end
act.idx = zeros(N,1) + nan;
act.hasidx = logical(zeros(N,1));
act.area = zeros(N,1);
act.hasarea = logical(zeros(N,1));

% Get image
img = mean(double(xdat.ccd.dat(:,:,cam,:)), 4);
[Y X] = size(img);
if X==4*Y
  img = interp2(img, [1:X], [1 1 [1:.25:Y] Y]');
  Y = 4*Y;
end
img = ace(img, X/20, X/8, Y/20, Y/8);
img = flipud(img);
img = img - min(img(:));
img = img / max(img(:));

% Normalize canonicals appropriately
can = mtc_denormalizecoords(can, act.norm);
cres = can;

str.ifn = ifn;
str.act = act;
str.cres = cres;
str.can = can;
str.img = img;
str.arealabel = arealabel;
