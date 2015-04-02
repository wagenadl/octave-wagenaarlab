function [gdspk, idx] = iselectspike(spk)
% ISELECTSPIKE - Interactive posthoc spike classification
%    gdspk = ISELECTSPIKE(spk) plots a raster of the spikes in SPK (previously
%    detected using REFRACTORYSPIKE or TEMPLATESPIKE) and lets the 
%    user interactively select which spikes belong to the neuron of interest.
%
%    Place the green and blue lines around the relevant dots (it does not
%    matter which one is above and which one is below). More handles
%    can be made by dragging the line; handles can be removed by dragging
%    them past the next handle.
%
%    [gdspk, idx] = ISELECTSPIKE(spk) also returns the index of selected spikes.
%
%    This version works in Octave and requires the IPlot package. In Matlab,
%    use SELECTSPIKE. 

global phsc_data

[w,h]=screensize;
figw = w/2-40;
figh = h/2-80;
f=ifigure;
iset(f, 'position',[20 40], 'size', [figw figh], ...
    'title', 'ISelectSpike');

iset(igca(), 'tag', 'graph');

phsc_data{f}.loaded=0;
phsc_data{f}.figw = figw;
phsc_data{f}.figh = figh;
phsc_data{f}.ylim = [-1 1];

h = ibutton('Done', @phsc_done);
iset(h, 'tag', 'done');
% ibutton('Zoom', @phsc_zoom);

% icallback(igca(), 'buttondownfcn', @phsc_click);

h = iimage(zeros(10, 10, 1));
iset(h, 'tag', 'trace');
% icallback(h, 'buttondownfcn', @phsc_click);

h = iplot([0 1], [0 0]);
iset(h, 'color', [0 0 1], 'linewidth', 2, 'tag', 'lowerline');
icallback(h, 'buttonmotionfcn', @phsc_move);
icallback(h, 'buttondownfcn', @phsc_press);
icallback(h, 'buttonupfcn', @phsc_release);

h = iplot([0 1], [1 1]);
iset(h, 'color', [0 1 0], 'linewidth', 2, 'tag', 'upperline');
icallback(h, 'buttonmotionfcn', @phsc_move);
icallback(h, 'buttondownfcn', @phsc_press);
icallback(h, 'buttonupfcn', @phsc_release);

h = ipoints(.5, 0);
iset(h, 'color', [0 0 1], 'markersize', 10, 'tag', 'lowerdots');
icallback(h, 'buttonmotionfcn', @phsc_move);
icallback(h, 'buttondownfcn', @phsc_press);
icallback(h, 'buttonupfcn', @phsc_release);

h = ipoints(.5, 1);
iset(h, 'color', [0 1 0], 'markersize', 10, 'tag', 'upperdots');
icallback(h, 'buttonmotionfcn', @phsc_move);
icallback(h, 'buttondownfcn', @phsc_press);
icallback(h, 'buttonupfcn', @phsc_release);

iset(f, '*xlim0', iget(igca(), 'xlim'));
iset(f, '*ylim0', iget(igca(), 'ylim'));

phsc_loaddat(f, spk);

iset(f, '*completed', 0);

while 1
  iwait(f);
  cancel=0;
  done=0;
  try
    done = iget(f, '*completed');
  catch
    cancel = 1;
  end
  if done
    break
  end
  if cancel
    break
  end
end

if done
  [gdspk, idx] = phsc_getdata(f);
  iclose(f);
else
  gdspk.tms = [];
  gdspk.amp = [];
end

if nargout<2
  clear idx
end


% ----------------------------------------------------------------------

function phsc_channelselect(h,x)
global phsc_data

figh = igcbf;
name = iget(h, 'tag');
idx = find(name=='-');
c = str2num(name(idx+1:end));
phsc_data{figh}.c = c;
for k=1:phsc_data{figh}.C
  iset(k, 'checked', k==c);
end

phsc_redraw(figh,1);


% ----------------------------------------------------------------------

function phsc_done(h, x)

f = iget(h, 'parent');
iset(f, '*completed', 1);
iresume

% ----------------------------------------------------------------------

function [gdspk,idx] = phsc_getdata(figh)
global phsc_data

gdspk.tms=[];
gdspk.amp=[];

for c=1:phsc_data{figh}.C
  idx = find(phsc_data{figh}.src.spk.chs==c);
  tt = phsc_data{figh}.src.spk.tms(idx);
  tt = tt/60;
  yy = phsc_data{figh}.src.spk.hei(idx);
  yy = sw_sig2log(yy);
  yy = yy*50/max(yy);

  x = phsc_data{figh}.lower_thr{c}(:,1);
  y = phsc_data{figh}.lower_thr{c}(:,2);
  [x,ord]=sort(x);
  y = y(ord);
  x=[min([0 min(x)-10]); x(:); max([max(tt) max(x)])+10] ;
  y=[y(1); y(:); y(end)];
  lower_thr = interp1(x,y,tt,'linear');

  x = phsc_data{figh}.upper_thr{c}(:,1);
  y = phsc_data{figh}.upper_thr{c}(:,2);
  [x,ord]=sort(x);
  y = y(ord);
  x=[min([0 min(x)-1]); x(:); max([max(tt) max(x)])+10];
  y=[y(1); y(:); y(end)];
  upper_thr = interp1(x,y,tt,'linear');
  
  if mean(upper_thr)<mean(lower_thr)
    ll=lower_thr;
    lower_thr=upper_thr;
    upper_thr=ll;
  end

  idx = idx(find(yy>lower_thr & yy<upper_thr));
  
  gdspk.tms = phsc_data{figh}.src.spk.tms(idx);
  gdspk.amp = phsc_data{figh}.src.spk.hei(idx);
end


% ----------------------------------------------------------------------

function phsc_loaddat(figh, spk)
global phsc_data

if isfield(spk, 'title')
  phsc_data{figh}.ifn = spk.title;
else
  phsc_data{figh}.ifn = 'data';
end

phsc_data{figh}.src.spk.tms = spk.tms;
if isfield(spk, 'chs')
  phsc_data{figh}.src.spk.chs = spk.chs;
else
  phsc_data{figh}.src.spk.chs = 1+0*spk.tms;
end
phsc_data{figh}.src.spk.hei = spk.amp;

phsc_process_spikes(figh);

% ----------------------------------------------------------------------

function phsc_move(h, but)
tag = iget(h, 'tag');
idx = iget(h, '*index');
xy0 = iget(h, '*xy0');

x = xy0(1);
y = xy0(2);

dxy = iget(igca, 'currentpoint') - iget(igca, 'downpoint');

x = x + dxy(1);
y = y + dxy(2);

global phsc_data
figh = igcf;
c=phsc_data{figh}.c;

switch tag
  case {'lowerline', 'lowerdots' }
    phsc_data{figh}.lower_thr{c}(idx, :) = [x y];
  case {'upperline', 'upperdots' }
    phsc_data{figh}.upper_thr{c}(idx, :) = [x y];
end

phsc_redraw(figh, 0);

% ----------------------------------------------------------------------

function phsc_press(h, but)
if but~=1
  return;
end

tag = iget(h, 'tag');
fprintf(1, 'Press %s\n', tag);

act = 0;

global phsc_data
figh = igcf;
c=phsc_data{figh}.c;

switch tag
  case { 'lowerline', 'lowerdots' }
    xx = phsc_data{figh}.lower_thr{c}(:,1);
    yy = phsc_data{figh}.lower_thr{c}(:,2);
    act = 1;
  case { 'upperline', 'upperdots' }
    xx = phsc_data{figh}.upper_thr{c}(:,1);
    yy = phsc_data{figh}.upper_thr{c}(:,2);
    act = 1;
end

if ~act
  return;
end

xy = iget(igca, 'currentpoint');
x = xy(1);
y = xy(2);

x
y
xx
yy
switch tag
  case { 'upperline', 'lowerline' }
    disp(1)
    ii = findfirst_ge(xx, x);
    if ii>0
      xx=[xx(1:ii-1); x; xx(ii:end)];
      yy=[yy(1:ii-1); y; yy(ii:end)];
    else
      xx=[xx; x];
      yy=[yy; y];
      ii=length(xx);
    end
  case { 'upperdots', 'lowerdots' }
    disp(2)
    ii = argmin((xx-xy(1)).^2);
end

iset(h, '*index', ii);
iset(h, '*xy0', [xx(ii) yy(ii)]);

switch tag
  case 'lowerline'
    phsc_data{figh}.lower_thr{c} = [xx, yy];
    phsc_redraw(figh, 0);
  case 'upperline'
    phsc_data{figh}.upper_thr{c} = [xx, yy];
    phsc_redraw(figh, 0);
end


% ----------------------------------------------------------------------

function phsc_process_spikes(figh)
global phsc_data

phsc_data{figh}.loaded = 1;
phsc_data{figh}.c = 1;

phsc_data{figh}.C = max(phsc_data{figh}.src.spk.chs);
phsc_data{figh}.T = max([max(phsc_data{figh}.src.spk.tms) 1]);

phsc_data{figh}.lower_thr = cell(1,phsc_data{figh}.C);
phsc_data{figh}.upper_thr = cell(1,phsc_data{figh}.C);

if isfield(phsc_data{figh}.src, 'chnames')
  phsc_data{figh}.chnames = phsc_data{figh}.src.chnames;
else
  phsc_data{figh}.chnames = cell(1,phsc_data{figh}.C);
end

dT = min(60, phsc_data{figh}.T/2)/60;

for c=1:phsc_data{figh}.C
  phsc_data{figh}.lower_thr{c} = [dT 10];
  phsc_data{figh}.upper_thr{c} = [dT 15];
end

for c=1:99
  h = ifind(sprintf('channelselect-%03i', c));
  if isempty(h)
    break;
  else
    idelete(h);
  end
end


ifigure(figh);

if phsc_data{figh}.C>1
  for c=1:phsc_data{figh}.C
    h=ibutton(sprintf('Ch%i %s',c,phsc_data{figh}.chnames{c}), ...
	@phsc_channelselect);
    iset(h, 'tag', sprintf('channelselect-%03i', c));
  end
end

iset(figh, 'title', sprintf('ISelectSpike: %s',phsc_data{figh}.ifn));

iset(figh, '*xlim0', [0 phsc_data{figh}.T/60]);
iset(figh, '*xlim', [0 phsc_data{figh}.T/60]);
iset(figh, '*ylim0', phsc_data{figh}.ylim);
iset(figh, '*ylim', phsc_data{figh}.ylim);

phsc_redraw(figh, 1);


% ----------------------------------------------------------------------

function phsc_redraw(figh, graphtoo)
global phsc_data

ax = ifind(figh, 'graph');
xlim = iget(figh, '*xlim');
iset(ax, 'xlim', xlim);

if graphtoo
  c = phsc_data{figh}.c;
  idx = find(phsc_data{figh}.src.spk.chs==c);
  xx = phsc_data{figh}.src.spk.tms(idx) / 60;
  yy = phsc_data{figh}.src.spk.hei(idx);
  yy = sw_sig2log(yy);
  yy = yy*50/max(yy);
  
  ylim = [0 0];
  if any(yy>0)
    ylim(2) = max(yy)*1.1;
  end
  if any(yy<0)
    ylim(1) = min(yy)*1.1;
  end
  iset(figh, '*ylim0', ylim);
  iset(ax, 'ylim', ylim);
  xlim = iget(figh, '*xlim0');

  [nn, xx, yy] = hist2(xx, yy, [xlim(1) diff(xlim)/2000 xlim(2)], ...
      [ylim(1) diff(ylim)/2000 ylim(2)]);
  nn = gsmooth(gsmooth(nn, 2.5)', 1)';
  xywh = [xx(1) yy(1) xx(end)-xx(1) yy(end)-yy(1)];
  siz = size(nn');
  nn = flipud(nn)./max(nn(:));
  bb = 1 - nn.^.06;
  gg = 1 - nn.^.4;
  rr = 1 - nn.^2.0;
  iset(ifind(ax, 'trace'), 'area', xywh, 'size', siz,  ...
      'cdata', cat(3, rr, gg, bb));
  iset(ax, 'xlabel', 'Time (min)');
  iset(ax, 'ylabel', 'Spike Amplitude');
end

c=phsc_data{figh}.c;
xx = phsc_data{figh}.lower_thr{c}(:,1);
yy = phsc_data{figh}.lower_thr{c}(:,2);

h = ifind(ax, 'lowerdots');
iset(h, 'xdata', xx, 'ydata', yy);

h = ifind(ax, 'lowerline');
iset(h, 'xdata',[xlim(1); xx; xlim(2)], 'ydata', [yy(1); yy; yy(end)]);

xx = phsc_data{figh}.upper_thr{c}(:,1);
yy = phsc_data{figh}.upper_thr{c}(:,2);
h = ifind(ax, 'upperdots');
iset(h, 'xdata', xx, 'ydata', yy);
h = ifind(ax, 'upperline');
iset(h, 'xdata', [xlim(1); xx; xlim(2)], 'ydata', [yy(1); yy; yy(end)]);

% ----------------------------------------------------------------------

function phsc_release(h, but)
if but~=1
  return;
end

tag = iget(h, 'tag');
fprintf(1, 'Release %s\n', tag);

act = 0;

global phsc_data
figh = igcf;
c=phsc_data{figh}.c;

xx = phsc_data{figh}.upper_thr{c}(:,1);
yy = phsc_data{figh}.upper_thr{c}(:,2);
while 1
  nn = find(xx(2:end)<xx(1:end-1), 1);
  if isempty(nn)
    break;
  else
    act = 1;
    xx(nn) = (xx(nn+1)+xx(nn))/2; xx(nn+1)=[];
    yy(nn) = (yy(nn+1)+yy(nn))/2; yy(nn+1)=[];
  end
end

yl = iget(figh, '*ylim0');
ymin = yl(1);
ymax = yl(2);

if any(yy>ymax)
  act = 1;
  yy(yy>ymax) = ymax;
end
if any(yy<ymin)
  act = 1;
  yy(yy<ymin) = ymin;
end

phsc_data{figh}.upper_thr{c} = [xx yy];

xx = phsc_data{figh}.lower_thr{c}(:,1);
yy = phsc_data{figh}.lower_thr{c}(:,2);
while 1
  nn = find(xx(2:end)<xx(1:end-1), 1);
  if isempty(nn)
    break;
  else
    act = 1;
    xx(nn) = (xx(nn+1)+xx(nn))/2; xx(nn+1)=[];
    yy(nn) = (yy(nn+1)+yy(nn))/2; yy(nn+1)=[];
  end
end

if any(yy>ymax)
  act = 1;
  yy(yy>ymax) = ymax;
end
if any(yy<ymin)
  act = 1;
  yy(yy<ymin) = ymin;
end

phsc_data{figh}.lower_thr{c} = [xx yy];

if act
  phsc_redraw(figh, 0);
end


% ----------------------------------------------------------------------

function x = sw_log2sig(y)
% SW_LOG2SIG   Convert logarithmic spike amplitude to linear representation
%    x = SW_LOG2SIG(y) converts the spike amplitude(s) Y from log scale
%    (for plotting) to linear scale (multiplier of RMS noise).

x = 15*sign(y).*(exp(abs(y)/20)-1);

% ----------------------------------------------------------------------

function y = sw_sig2log(x)
% SW_SIG2LOG   Convert linear spike amplitude to log representation
%    y = SW_SIG2LOG(x) converts the spike amplitude(s) X from linear scale
%    (multiplier of RMS noise) to log scale for plotting.

y = 20*sign(x).*log(1+abs(x)/15);
