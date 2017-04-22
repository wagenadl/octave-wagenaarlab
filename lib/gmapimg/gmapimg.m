function gmapimg(ifn, dv, imgfn)
% GMAPIMG - GUI for identifying ROIs with canonical cells
%    GMAPIMG('trial.xml', 'dorsal') or GMAPIMG('trial.xml', 'ventral')
%    loads the ROIs and image data from TRIAL.XML (which must be a
%    VScope trial file and displays them along with either the dorsal
%    or ventral canonical map. 
%    GMAPIMG('file.mat') loads a file previously saved with GMAPIMG.
%    GMAPIMG('trial.xml', 'dorsal', 'image.jpg') replaces the image data 
%    from the trial with the named image file. ('ventral' works too, of
%    course.)
%    GMAPIMG('file.mat', 'image.jpg') does the same for previously saved
%    data.
%    Instead of the name of an image file, you can also specify a tuple
%    { 'image.jpg', flip-x, flip-y, rotate } to load the image but first
%    rotate it. (flip-x and flip-y must be either 0 or 1, rotate must
%    be 0/90/180/270 and specifies degree of anticlockwise rotation.)

global cd_data

switch nargin
  case 1
    x = gmi_load(ifn);
  case 2
    % Could be TRIAL and SIDE, or OLDFILE and IMGFILE
    if iscell(dv) || ~isempty(find(dv=='.'))
      % Treat it as an image file
      x = gmi_load(ifn);
      x.img = gmi_loadimg(dv);
    else
      x = gmi_loadvscope(ifn, dv);
    end
  case 3
    x = gmi_loadvscope(ifn, dv);
    x.img = gmi_loadimg(imgfn);
  otherwise
   error('gmapimg needs at least one argument, and at most three');
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

ibutton(2, 'Hide letters', @(h,x) (gmi_hideletters(f)));
%ibutton(4, 'Screenshot', @(h,x) (gmi_screenshot(f)));

ibutton(4, 'Save', @(h,x) (gmi_save(f)));
iunfreeze;
