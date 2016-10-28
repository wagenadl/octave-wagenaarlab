function gmapimg(ifn, dv)

global cd_data

if nargin==0
  ifn = '';
  dv = 'dorsal';
end

if isempty(ifn)
  ifn = '/dell1/dw/analysis/2016/yusuke-pca-lda-160426/orig/160426/004.xml';
  if ~exist(ifn)
    ifn = '/home/wagenaar/werk/tmp/yusuke-pca-lda-160426/orig/160426/004.xml';
  end
end

if nargin==1
  % Load previously saved data
  x=load(ifn);
  if ~isfield(x, 'act') || ~isfield(x, 'can') || ~isfield(x, 'ifn') ...
        || ~isfield(x, 'cres') || ~isfield(x, 'arealabel') ...
	|| ~isfield(x, 'img')
    error('Cannot load data');
  end
  act = x.act;
  can = x.can;
  ifn = x.ifn;
  cres = x.cres;
  img = x.img;
  arealabel = x.arealabel;
else
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
  act = gmi_loadrois(xdat);
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
  cres.x = can.x;
  cres.y = can.y;
end

xywh = get(0, 'screensize');
w = xywh(3);
h = xywh(4);
R = min([2048, w-50, h-80]);

[Y X] = size(img);

f = ifigure(R,R);

cd_data{f} = struct();
cd_data{f}.ifn = ifn;
cd_data{f}.act = act;
cd_data{f}.cres = cres;
cd_data{f}.can = can;
cd_data{f}.img = img;

cd_data{f}.avis = 1;
cd_data{f}.cvis = 1;
cd_data{f}.area = 1;
cd_data{f}.arealabel = arealabel;
cd_data{f}.pressact = 0;

gmi_plotimage(f);
axis tight
iset(cd_data{f}.h_img, 'buttondownfcn', @gmi_pressimage);

%% Plot canonicals
N = length(can.id);
ht = zeros(N,1);
for n=1:N
  ht(n) = itext(cres.x(n), cres.y(n), cd_shortid(can.id{n}), ...
      'tag', 'ht', 'userdata', n);
end
cd_data{f}.ht = ht;
set(ht, 'horizontalalignment', 'center', ...
    'verticalalignment', 'middle', 'fontsize', FSC);
set(ht, 'buttondownfcn', @gmi_pressimage);

%% Plot actuals
N = length(act.r);
hta = zeros(N,1);
for n=1:N
  hta(n) = text(act.x(n), act.y(n), cd_shortid(act.id{n}), ...
      'tag', 'hta', 'userdata', n);
  if act.hasidx(n)
    set(hta(n), 'fontweight', 'bold');
  else
    set(hta(n), 'fontangle', 'italic');    
  end
end
cd_data{f}.hta = hta;
set(hta, 'buttondownfcn', @gmi_pressimage);

set(hta, 'horizontalalignment', 'center', ...
    'verticalalignment', 'middle', ...
    'color', [1 0 0], 'fontsize', FSA);
  
%% Create controls
uicontrol('string', 'Canonical', ...
    'callback', @cd_togglecan, ...
    'position', [0 0 BW BH]);
uicontrol('string', 'Actual', ...
    'callback', @cd_toggleact, ...
    'position', [BW 0 BW BH]);
for k=1:length(arealabel)
  uicontrol('string', arealabel{k}, ...
      'callback', @(h,x) (cd_setarea(k)), ...
      'position', [BW*(k-1) R-BH BW BH], 'userdata', k);
end

uicontrol('string', 'Unalign', ...
    'callback', @(h,x) (gmi_unalign(f)), ...
    'position', [2*BW+DX 0 BW BH]);
uicontrol('string', 'Global align', ...
    'callback', @(h,x) (gmi_quickalign(f)), ...
    'position', [3*BW+DX 0 BW BH]);
uicontrol('string', 'Local align', ...
    'callback', @(h,x) (gmi_localalign(f)), ...
    'position', [4*BW+DX 0 BW BH]);

uicontrol('string', 'Auto assign', ...
    'callback', @(h,x) (cd_autoassign(f)), ...
    'position', [5*BW+2*DX 0 BW BH]);
uicontrol('string', 'Unassign', ...
    'callback', @(h,x) (cd_unassign(f)), ...
    'position', [6*BW+2*DX 0 BW BH]);

uicontrol('string', 'Save', ...
    'callback', @(h,x) (cd_save(f)), ...
    'position', [7*BW+3*DX 0 BW BH]);

delete(h0);
set(findobj(f, 'type', 'uicontrol'), 'fontsize', FSUIC)
