function grayout
ifn = '/home/lanski/Desktop/Photos before 091023/IMG_1008cropSat25a.pngpng';
xywh=get(0,'screensize');
f=figure;
set(f,'menubar','none');
set(f,'position',xywh);
set(f,'doublebuf','on');

setappdata(f, 'mode',  'orig');
setappdata(f, 'gamma', 1.0);
setappdata(f, 'x',     0);
setappdata(f, 'y',     0);
setappdata(f, 'neighbor', 0);

axes('position',[0 0 1 1]); hold on
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'ydir','rev');
set(gca,'color',[.5 .5 .5]);
set(gcf,'color',[.5 .5 .5]);
set(gcf,'keypressfcn',@go_key);

uicontrol('string','Gray', 'callback',@go_modegray,...
    'style','pushbutton','position',[5 35 100 25]);
uicontrol('string','50%', 'tag','gray', 'callback',@go_setgray,...
    'style','edit','position',[5 5 50 25],'background','w');
uicontrol('string','-', 'callback',@go_grayminus,...
    'style','pushbutton','position',[60 5 20 25]);
uicontrol('string','+', 'callback',@go_grayplus,...
    'style','pushbutton','position',[85 5 20 25]);

uicontrol('string','Semi', 'callback',@go_modesemi,...
    'style','pushbutton','position',[5 105 100 25]);
uicontrol('string','50%', 'tag','semi', 'callback',@go_setsemi,...
    'style','edit','position',[5 75 50 25],'background','w');
uicontrol('string','-', 'callback',@go_semiminus,...
    'style','pushbutton','position',[60 75 20 25]);
uicontrol('string','+', 'callback',@go_semiplus,...
    'style','pushbutton','position',[85 75 20 25]);

uicontrol('string','Original', 'callback',@go_modeorig,...
    'style','pushbutton','position',[5 145 100 25]);

uicontrol('string','1x1', 'callback',@go_1x1,...
   'style','pushbutton','position',[5 190 30 25]);
uicontrol('string','3x3', 'callback',@go_3x3,...
   'style','pushbutton','position',[40 190 30 25]);
uicontrol('string','5x5', 'callback',@go_5x5,...
   'style','pushbutton','position',[75 190 30 25]);

uicontrol('string','<', 'callback',@go_scootleft,...
	  'style','pushbutton', 'position',[5 250 30 25]);
uicontrol('string','>', 'callback',@go_scootright,...
	  'style','pushbutton', 'position',[75 250 30 25]);
uicontrol('string','^', 'callback',@go_scootup,...
	  'style','pushbutton', 'position',[40 270 30 25]);
uicontrol('string','v', 'callback',@go_scootdown,...
	  'style','pushbutton', 'position',[40 230 30 25]);


uicontrol('string','Load', 'callback',@go_loadimage,...
    'style','pushbutton','position',[5 xywh(4)-30 100 25]);
uicontrol('string','Quit', 'callback',@go_quit,...
    'style','pushbutton','position',[5 xywh(4)-60 100 25]);

uicontrol('string','Center', 'callback',@go_center,...
    'style','pushbutton','position',[5 xywh(4)/2+110 100 25]);
uicontrol('string','Zoom in', 'callback',@go_zoomin,...
    'style','pushbutton','position',[5 xywh(4)/2+80 100 25]);
uicontrol('string','Zoom out', 'callback',@go_zoomout,...
    'style','pushbutton','position',[5 xywh(4)/2+50 100 25]);
uicontrol('string','View all', 'callback',@go_zoomall,...
    'style','pushbutton','position',[5 xywh(4)/2+20 100 25]);

uicontrol('string','(-,-)', 'tag','xy', 'callback',@go_xy,...
    'style','edit','position',[5 xywh(4)/2-40 100 25], ...
    'background',[.9 .9 .9]);
uicontrol('string','- - -', 'tag','rgb',...
    'style','text','position',[5 xywh(4)/2-70 100 25], ...
    'background',[.9 .9 .9]);

gos_loadimage(f, ifn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function go_loadimage(hh,x)
fn = dwgetfile('.png', 'Load image file', go_figure(hh));
if ~isempty(fn)
  gos_loadimage(go_figure(hh), fn);
end

%%%%%%%
function gos_loadimage(f,ifn)
img = imread(ifn);
img = double(img)/255;
gamma = getappdata(f,'gamma');
img = img .^ gamma; 
setappdata(f,'image',img);
[Y X C] = size(img);
setappdata(f, 'x',     0);
setappdata(f, 'y',     0);
set(findobj(f,'tag','xy'),'string','(-,-)');
set(findobj(f,'tag','rgb'),'string','- - -');
gos_redraw(f);
gos_setzoom(f,[.5 .5 X Y]);

%%%%%%%
function gos_redraw(f)
img = getappdata(f,'image');
semi = sscanf(get(findobj(f,'tag','semi'),'string'),'%g') / 100;
gray = 1 - sscanf(get(findobj(f,'tag','gray'),'string'),'%g') / 100;
x = getappdata(f,'x');
y = getappdata(f,'y');
[Y X C]=size(img);
R = getappdata(f,'neighbor');
yy=y+[-R:R];
xx=x+[-R:R];
yy=yy(yy>0 & yy<=Y);
xx=xx(xx>0 & xx<=X);
pix = img(yy,xx,:);
switch  getappdata(f,'mode')
  case 'orig'
    ;
  case 'semi'
    img = semi*img + (1-semi)*gray;
  case 'gray'
    img = 0*img + gray;
end
img(yy,xx,:) = pix;
cla
h=image(img);
set(gca,'color',[0 0 0]+gray);
set(gcf,'color',[0 0 0]+gray);
set(h,'buttondownfcn',@go_click);

%%%%%%%
function gos_setzoom(f,xywh)
x=xywh(1);
y=xywh(2);
w=xywh(3);
h=xywh(4);
a=h/w;
XYWH=get(f,'position');
W=XYWH(3);
H=XYWH(4);
A=H/W;
if a<A
  h1 = w*A;
  y = y - (h1-h)/2;
  h = h1;
else
  w1 = h/A;
  x = x - (w1-w)/2;
  w = w1;
end
x=floor(x+.5)-.5;
y=floor(y+.5)-.5;
w=ceil(w);
h=ceil(h);
axis([x x+w y y+h]);
hh=findobj(f,'type','axes');
set(hh,'unit','pix');
a=w/h;
xywh=get(hh,'position');
xywh=[xywh(1)+xywh(3)-a*xywh(4) xywh(2) a*xywh(4) xywh(4)];
set(hh,'position',xywh);

function go_center(hh,x)
ax = axis;
w = ax(2)-ax(1);
x0 = (ax(1)+ax(2))/2;
h = ax(4)-ax(3);
y0 = (ax(3)+ax(4))/2;
x = getappdata(go_figure(hh),'x');
y = getappdata(go_figure(hh),'y');
if x>0 & y>0
  gos_setzoom(go_figure(hh),[x-w/2 y-h/2 w h]);
else
  gos_setzoom(go_figure(hh),[x0-w/2 y0-h/2 w h]);
end

function go_scootleft(hh,x)
gos_scoot(hh,-1,0)

function go_scootright(hh,x)
gos_scoot(hh,1,0)

function go_scootup(hh,x)
gos_scoot(hh,0,-1)

function go_scootdown(hh,x)
gos_scoot(hh,0,1)

function gos_scoot(hh,dx,dy)
ax=axis;
ax(1:2)=ax(1:2)+dx;
ax(3:4)=ax(3:4)+dy;
axis(ax);

function go_zoomin(hh,x)
ax = axis;
w = ax(2)-ax(1);
x0 = (ax(1)+ax(2))/2;
h = ax(4)-ax(3);
y0 = (ax(3)+ax(4))/2;
x = getappdata(go_figure(hh),'x');
y = getappdata(go_figure(hh),'y');
if x>0 & y>0
  gos_setzoom(go_figure(hh),[x-w/4 y-h/4 w/2 h/2]);
else
  gos_setzoom(go_figure(hh),[x0-w/4 y0-h/4 w/2 h/2]);
end

function go_zoomout(hh,x)
ax = axis;
w = ax(2)-ax(1);
x0 = (ax(1)+ax(2))/2;
h = ax(4)-ax(3);
y0 = (ax(3)+ax(4))/2;
x = getappdata(go_figure(hh),'x');
y = getappdata(go_figure(hh),'y');
if x>0 & y>0
  gos_setzoom(go_figure(hh),[x-w y-h w*2 h*2]);
else
  gos_setzoom(go_figure(hh),[x0-w y0-h w*2 h*2]);
end

function go_zoomall(hh,x)
img = getappdata(go_figure(hh),'image');
[Y X C] = size(img);
gos_setzoom(go_figure(hh),[.5 .5 X Y]);

function go_modeorig(hh,x)
setappdata(go_figure(hh),'mode','orig');
gos_redraw(go_figure(hh));

function go_modesemi(hh,x)
setappdata(go_figure(hh),'mode','semi');
gos_redraw(go_figure(hh));

function go_modegray(hh,x)
setappdata(go_figure(hh),'mode','gray');
gos_redraw(go_figure(hh));

function go_setsemi(hh,x)
gos_redraw(go_figure(hh));

function go_semiminus(hh,x)
h=findobj(go_figure(hh),'tag','semi');
gr = sscanf(get(h,'string'),'%g');
gr = max(gr-5,0);
set(h,'string',sprintf('%g%%',gr));
gos_redraw(go_figure(hh));

function go_semiplus(hh,x)
h=findobj(go_figure(hh),'tag','semi');
gr = sscanf(get(h,'string'),'%g');
gr = min(gr+5,100);
set(h,'string',sprintf('%g%%',gr));
gos_redraw(go_figure(hh));

function go_grayminus(hh,x)
h=findobj(go_figure(hh),'tag','gray');
gr = sscanf(get(h,'string'),'%g');
gr = max(gr-5,0);
set(h,'string',sprintf('%g%%',gr));
gos_redraw(go_figure(hh));

function go_grayplus(hh,x)
h=findobj(go_figure(hh),'tag','gray');
gr = sscanf(get(h,'string'),'%g');
gr = min(gr+5,100);
set(h,'string',sprintf('%g%%',gr));
gos_redraw(go_figure(hh));

function go_setgray(hh,x)
gos_redraw(go_figure(hh));

function go_1x1(hh,x)
f=go_figure(hh);
setappdata(f,'neighbor',0);
gos_redraw(f);

function go_3x3(hh,x)
f=go_figure(hh);
setappdata(f,'neighbor',1);
gos_redraw(f);

function go_5x5(hh,x)
f=go_figure(hh);
setappdata(f,'neighbor',2);
gos_redraw(f);

function go_xy(hh,x)
f=go_figure(hh);
txt = get(hh,'string');
[xy,n]=sscanf(txt,'(%i,%i)');
if n==2
  x=round(xy(1));
  y=round(xy(2));
  setappdata(f,'x',x);
  setappdata(f,'y',y);
  gos_showrgb(f);
  gos_redraw(f);
end

function gos_showrgb(f)
img = getappdata(f,'image');
x=getappdata(f,'x');
y=getappdata(f,'y');
[Y X C] = size(img);
set(findobj(f,'tag','xy'),'string',sprintf('(%i,%i)',x,y));
if x>0 & x<=X & y>0 & y<=Y
  pix=img(y,x,:);
  txt=sprintf('%.0f%% %.0f%% %.0f%%',pix(1)*100,pix(2)*100,pix(3)*100);
else
  txt='- - -';
end
set(findobj(f,'tag','rgb'),'string',txt);

function gos_move(hh,dx,dy)
f=go_figure(hh);
x=getappdata(f,'x');
y=getappdata(f,'y');
x=x+dx;
y=y+dy;
setappdata(f,'x',x);
setappdata(f,'y',y);
gos_showrgb(f);
gos_redraw(f);


function go_click(hh,x)
but = get(go_figure(hh),'selectiontype');
hax=get(hh,'parent');
hh=go_figure(hh);
switch but
  case 'alt'
    go_zoomout(hh,x)
  otherwise
    xy = get(hax,'currentpoint');
    xy0=xy(1,1:2);
    rbbox;
    xy = get(hax,'currentpoint');
    xy1=xy(1,1:2);
    dd=(xy1(1)-xy0(1))^2 + (xy1(2)-xy0(2))^2;
    if dd<5^2
      x = round(xy0(1));
      y = round(xy0(2));
      setappdata(go_figure(hh),'x',x);
      setappdata(go_figure(hh),'y',y);
      img = getappdata(go_figure(hh),'image');
      [Y X C] = size(img);
      set(findobj(go_figure(hh),'tag','xy'),'string',sprintf('(%i,%i)',x,y));
      if x>0 & x<=X & y>0 & y<=Y
	pix=img(y,x,:);
	txt=sprintf('%.0f%% %.0f%% %.0f%%',pix(1)*100,pix(2)*100,pix(3)*100);
      else
	txt='- - -';
      end
      set(findobj(go_figure(hh),'tag','rgb'),'string',txt);      
      gos_redraw(go_figure(hh));
      if strcmp(but,'open')
	go_figure(hh)
	go_zoomin(hh,x);
      end
    else
      x=min(xy0(1),xy1(1));
      y=min(xy0(2),xy1(2));
      w=abs(xy0(1)-xy1(1));
      h=abs(xy0(2)-xy1(2));
      gos_setzoom(go_figure(hh),[x y w h]);
    end
end

function go_key(hh,x)
a=get(go_figure(hh),'currentchar');
switch a
  case 'j'
    gos_move(hh,-1,0)
  case 'l'
    gos_move(hh,1,0)
  case 'i'
    gos_move(hh,0,-1)
  case 'k'
    gos_move(hh,0,1)
  case ' '
    go_center(hh,x)
end

 

function go_quit(hh,x)
close(go_figure(hh))

function f = go_figure(h)
f=h;
while f~=0
  h=f;
  f=get(h,'parent');
end
f=h;

