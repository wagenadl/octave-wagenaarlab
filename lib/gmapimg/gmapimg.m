function gmapimg(ifn, dv)

global cd_data

switch nargin
 case 0
  if exist('test.mat')
    x = load('test.mat');
  else 
    dv = 'dorsal';
    ifn = '/dell1/dw/analysis/2016/yusuke-pca-lda-160426/orig/160426/004.xml';
    if ~exist(ifn)
      ifn = '/home/wagenaar/werk/tmp/yusuke-pca-lda-160426/orig/160426/004.xml';
    end
    x = gmi_loadvscope(ifn, dv);
  end
 case 1
  x = gmi_load(ifn);
 case 2
  x = gmi_loadvscope(ifn, dv);
 otherwise
 error('gmapimg(ifn, dv)');
end

x = gmi_cleanup(x);

xywh = get(0, 'screensize');
R = (xywh(4) - 100) * .8;

[Y X] = size(x.img);

f = ifigure(R, R+60);
ifreeze;

cd_data{f} = x;

cd_data{f}.avis = 1;
cd_data{f}.cvis = 1;
cd_data{f}.area = 1;
cd_data{f}.pressact = 0;
cd_data{f}.presspt = [];

gmi_plotimage(f);
iset(igca(), 'xaxis', 'off', 'yaxis', 'off');
iset(igca(), 'buttondownfcn', @gmi_buttondown);
iset(igca(), 'buttonupfcn', @gmi_buttonup);

gmi_plotcanact(f)
  
%% Create controls
ibutton(3, 'Canonical', @(h,x) (gmi_togglecan(f)));
ibutton(3, 'Actual', @(h,x) (gmi_toggleact(f)));

for k=1:length(x.arealabel)
  ibutton(1, x.arealabel{k}, @(h,x) (gmi_setarea(f, k)));
end

ibutton(3, 'Unalign', @(h,x) (gmi_unalign(f)));
ibutton(3, 'Global align', @(h,x) (gmi_quickalign(f)));
ibutton(3, 'Local align', @(h,x) (gmi_localalign(f)));

ibutton(3, 'Auto assign', @(h,x) (gmi_autoassign(f)));
ibutton(3, 'Unassign', @(h,x) (gmi_unassign(f)));

ibutton(4, 'Save', @(h,x) (gmi_save(f)));
iunfreeze;
