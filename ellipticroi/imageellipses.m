function imageellipses(usepartner,clearfirst)
% IMAGEELLIPSES(usepartner,clearfirst) allows user to draw or modify
% ellipses in currently displayed images.
% If USEPARTNER is given and non-zero, dashed ellipses are drawn in all
% other images for reference.
% If CLEARFIRST is given and non-zero, any previously drawn ellipses are
% forgotten. (In no case are old ellipses redrawn or visually removed.)
%
% User actions: LEFT MOUSE DRAG creates a new ellipse or
%                               moves an existing ellipse if inside other.
%               RIGHT MOUSE DRAG resizes or rotates an existing ellipse.
%               MIDDLE MOUSE CLICK deletes an existing ellipse

if nargin<1 | isempty(usepartner)
  usepartner=0;
end
if nargin<2 | isempty(clearfirst)
  clearfirst=0;
end

hh=findobj(gcf,'type','axes');
usehh=[];
for h = hh(:)'
  axes(h); hold on
  cc=findobj(h,'type','image');
  use = ~isempty(cc);
  if use
    cc=get(h,'children');
    set(cc,'buttondownfcn',@ie_doit);
    usehh=[usehh h];
  end
end

for h = usehh(:)'
  if clearfirst
    setappdata(h,'ellipses',[]);
  end
  if usepartner
    setappdata(h,'ellipses_partners',usehh(usehh~=h));
  else
    setappdata(h,'ellipses_partners',[]);
  end
  ie_fullredraw(h);
end
return

function ie_fullredraw(h)
try
  hh = getappdata(h,'ellipses_h');
  delete(hh);
catch
  ;
end
try
  phh = getappdata(h,'ellipses_partner_h');
  delete(phh);
catch
  ;
end
try
  thh = getappdata(h,'ellipses_text_h');
  delete(thh);
catch
  ;
end

xyrras = normellipse(getappdata(h,'ellipses'));
setappdata(h,'ellipses',xyrras);
[X N] = size(xyrras);
pp = getappdata(h,'ellipses_partners'); P=length(pp);
hh=zeros(1,N);
phh=zeros(P,N);
thh=zeros(1,N);

axes(h); hold on
for n=1:N
  hh(n) = plotellipse(xyrras(:,n),'color',[0 .8 1],'linew',1);
  thh(n) = text(xyrras(1,n),xyrras(2,n),sprintf('%i',n));
end
set(hh,'buttondownfcn',@ie_doit);
set(thh,'buttondownfcn',@ie_doit);
set(thh,'horizontala','center','color',[0 .5 1]);
setappdata(h,'ellipses_h',hh);
setappdata(h,'ellipses_text_h',thh);

for p=1:P
  axes(pp(p));
  for n=1:N
    phh(p,n) = plotellipse(xyrras(:,n),'color',[0 .8 1],'linew',1,'linest','--');
  end
end
setappdata(h,'ellipses_partner_h',phh);

drawnow
return



function ie_doit(c,x)
h=get(c,'parent');
a=get(gcbf,'selectiontype');

if strcmp(a,'alt')
  % Right button
  ie_move_or_change(h,0);
elseif strcmp(a,'extend')
  % Middle button
  ie_delete_if_click(h)
else
  % Left button
  ie_new_or_move(h);
end
return

function ie_delete_if_click(h)
xyxy = rbellipse(h);

if xyxy(1)==xyxy(3) & xyxy(2)==xyxy(4)
  ie_delete(h,xyxy);
end
return

function ie_new_or_move(h)
xy = get(h,'currentpoint'); xy=xy(1,1:2)';
xyrras = getappdata(h,'ellipses'); [A,N]=size(xyrras);
if N>0
  dds = (xy(1)-xyrras(1,:)).^2 + (xy(2)-xyrras(2,:)).^2;
  [dum,k] = min(dds);
  if inellipse(xy,xyrras(:,k),1)
    ie_move_or_change(h,1);
  else
    ie_new(h);
  end
else
  ie_new(h);
end
return

function ie_delete(h,xyxy)
xyrras = getappdata(h,'ellipses'); [A,N]=size(xyrras);
hh = getappdata(h,'ellipses_h'); M=length(hh);
if N>0
  dds = (xyxy(1)-xyrras(1,:)).^2 + (xyxy(2)-xyrras(2,:)).^2;
  [dum,k] = min(dds);
  if inellipse(xyxy,xyrras(:,k))
    %% fprintf(1,'Delete %i\n',k);
    delete(hh(k));
    phh = getappdata(h,'ellipses_partner_h');
    thh = getappdata(h,'ellipses_text_h');
    delete(phh(:,k));
    delete(thh(:,k));
    xyrras = xyrras(:,[[1:k-1] [k+1:N]]);
    hh=hh([[1:k-1] [k+1:N]]);
    phh = phh(:,[[1:k-1] [k+1:N]]);
    thh = thh(:,[[1:k-1] [k+1:N]]);
    setappdata(h,'ellipses',xyrras);
    setappdata(h,'ellipses_h',hh);
    setappdata(h,'ellipses_partner_h',phh);
    setappdata(h,'ellipses_text_h',thh);
    for q=1:length(thh)
      set(thh(q),'string',sprintf('%i',q));
    end
  else
    %% fprintf(1,'No delete %i\n',k);
  end
else
  %% fprintf(1,'No delete: no ellipses\n');
end
return

function ie_new(h,xyxy)
if nargin<2
  xyxy = rbellipse(h);
end
xyrras = getappdata(h,'ellipses'); [A,N]=size(xyrras);
hh = getappdata(h,'ellipses_h'); M=length(hh);
xyrra = normellipse(xyxy);
if xyrra(3)<1 | xyrra(4)<1
  return
end
xyrras = [xyrras xyrra];
setappdata(h,'ellipses',xyrras);
r = plotellipse(xyrra,'color',[0 .5 1],'linew',1);
set(r,'buttondownfcn',@ie_doit);
hh = [hh r];
setappdata(h,'ellipses_h',hh);

thh = getappdata(h,'ellipses_text_h');
t = text(xyrra(1),xyrra(2),sprintf('%i',length(thh)+1));
set(t,'buttondownfcn',@ie_doit);
set(t,'horizontala','center','color',[0 .5 1]);
thh = [thh t];
setappdata(h,'ellipses_text_h',thh)
phh = getappdata(h,'ellipses_partner_h');
pp = getappdata(h,'ellipses_partners');
rr = 0*pp;
for p=1:length(pp)
  axes(pp(p));
  rr(p) = plotellipse(xyrra,'color',[0 .5 1],'linew',1,'linest','--');
end
set(rr,'buttondownfcn',@ie_doit);
phh = [phh rr];
setappdata(h,'ellipses_partner_h',phh);
return

function ie_move_or_change(h,move_not_change)
xy = get(h,'currentpoint'); xy=xy(1,1:2);
xyrras = getappdata(h,'ellipses'); [A,N]=size(xyrras);
if isempty(xyrras)
  return
end

if move_not_change
  dds = (xy(1)-xyrras(1,:)).^2 + (xy(2)-xyrras(2,:)).^2;
  [dum,k] = min(dds);
  if ~inellipse(xy,xyrras(:,k),2)
    return
  end
  xyrras(:,k) = rbmoveellipse(xyrras(:,k),h);
else
  dd = zeros(1,N);
  for n=1:N
    dd(n) = disttoellipse(xy,xyrras(:,n));
  end
  [d,k] = min(dd);
  if d>2
    return
  end
  xyrras(:,k) = rbaltellipse(xyrras(:,k),h,1);
end

setappdata(h,'ellipses',xyrras);

hh = getappdata(h,'ellipses_h'); M=length(hh);
delete(hh(k));
hh(k) = plotellipse(xyrras(:,k),'color',[0 .5 1],'linew',1);
set(hh(k),'buttondownfcn',@ie_doit);
setappdata(h,'ellipses_h',hh);

thh = getappdata(h,'ellipses_text_h');
set(thh(k),'position',xyrras(1:2,k));

phh = getappdata(h,'ellipses_partner_h');
pp = getappdata(h,'ellipses_partners');
delete(phh(:,k));
for p=1:length(pp)
  axes(pp(p));
  phh(p,k) = plotellipse(xyrras(:,k),'color',[0 .5 1],'linew',1,'linest','--');
end
set(phh(:,k),'buttondownfcn',@ie_doit);
setappdata(h,'ellipses_partner_h',phh);

return

