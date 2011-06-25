function [aimg,tind,yind,cmap] = ss_overlayclust(spikes, varargin)
% SS_OVERLAYCLUST - Visualize spike clusters from Chronux spike sorting
%    SS_OVERLAYCLUST(spikes), where SPIKES is from Chronux's SS_AGGREGATE,
%    or SS_KMEANS, visualizes the clusters by overlaying them all in one
%    plot with new colors.
%    SS_OVERLAYCLUST(spikes, k, v, ...) specifies additional options:
%      oversamp: temporal oversampling
%      ybins: number of bins in vertical space
%      outliers: if set, overlay outliers
%      selection: plot only numbered clusters
%      darker: make plots darker by given factor
%      centroids: overlay centroids in plot
%      marksamples: draw ticks for sample clock
%    [img, tind, yind] = SS_OVERLAYCLUST(...) returns image and coordinates
%    rather than plotting it. TIND is in milliseconds, yind in data units.

opts = getopt('oversamp ybins=100 outliers=0 selection darker=0 cmap centroids=0 marksamples=0', varargin);

if isfield(spikes,'hierarchy')
  asg = spikes.hierarchy.assigns;
  cls = 1;
elseif isfield(spikes, 'overcluster')
  asg = spikes.overcluster.assigns;
  cls = 1;
elseif 1 % any(isinf(spikes.threshV)) | ~isfield(spikes, 'amplitude')
  asg = ceil([1:length(spikes.spiketimes)]*10/length(spikes.spiketimes));
  cls = 0;
else
  asg = 1 + (spikes.amplitude<0);
  cls = 0;
end

N=max(asg);
yy = hist(asg,[0:N]);
if isempty(opts.selection)
  yy(1) = 0; % drop outliers
else
  for n=0:N
    if ~any(opts.selection==n)
      yy(n+1)=0;
    end
  end
end
renum = find(yy>0) - 1;
asgmap = cumsum(yy>0);
asgmap(yy==0)=0;
newasg = asgmap(asg+1);
N = max(newasg);

M = max(asg);
cc = jet(1024);
if cls
  y0 = zeros(M,1);
  for m=1:M
    idx = find(asg==m);
    if ~isempty(idx)
      y0(m) = mean(max((spikes.waveforms(idx,:)),[],2));
    end
  end
  [dd,ord] = sort(y0); ord(ord)=1:M;
  cc = cc(1+mod(650*ord,1024),:);
else
  cc = cc(round(1+[0:M-1]*1023/(M-1)),:);
end
cc = [[1 1 1]; cc];

if ~isempty(opts.cmap)
  cc = 1-opts.cmap;
end

ymin = min(min(spikes.waveforms(newasg>0,:)));
ymax = max(max(spikes.waveforms(newasg>0,:)));
pky = zeros(N,1);
vly = zeros(N,1);
pki = zeros(N,1);
vli = zeros(N,1);
centroids = cell(N,1);
for n=1:N
  idx = find(newasg==n);
  wv = spikes.waveforms(idx,:);
  wv0 = mean(wv);
  centroids{n} = wv0;
  [pky(n),pki(n)] = max(wv0);
  [vly(n),vli(n)] = min(wv0);
  if ~isempty(opts.oversamp)
    T = size(wv,2);
    tinterp = [1:1/opts.oversamp:T];
    wv = interp1([1:T]',wv',tinterp, 'spline')';
  end
  wv(1,1)=ymin; wv(1,end)=ymax; % Ugly hack to force decent behavior from histxt
  
  [img{n},tind,yind] = histxt(wv, opts.ybins);
  if ~isempty(opts.oversamp)
    tind = (tind-1)/opts.oversamp + 1;
  end
  tind = (tind - spikes.threshT) * 1000/spikes.Fs;
  img{n}(1,1)=0;
  img{n}(1,end)=0; % Blot out ugly hack
  mxintens(n) = max(img{n}(:));
end
[Y X] = size(img{1});
aimg = zeros(Y*X,3);
mxint = max(mxintens);
for n=1:N
  im = img{n}(:);
  im = im/mxintens(n);
  if opts.darker>1
    im = im*opts.darker;
    im(im>1) = 1;
  end
  aimg = aimg + im*cc(renum(n)+1,:);
end
aimg(aimg>1) = 1; % clip
aimg = reshape(aimg, [Y,X,3]);

aimg = 1 - aimg;

if nargout==0
  cla
  % Draw main graph
  image(tind, yind, aimg);
  axis tight
  set(gca,'tickdir','out');
  set(gca,'ydir','normal');
  hold on

  % Add sample clock markers
  if opts.marksamples
    if isfield(spikes,'Fs0')
      fs = spikes.Fs0;
    else
      fs = spikes.Fs;
    end
    a=axis;
    X0=1e3/fs*floor(a(1)/(1e3/fs));
    for x=X0:1e3/fs:a(2)
      plot([x x],a(3)+[.99 1]*(a(4)-a(3)),'k');
      plot([x x],a(3)+[0 .01]*(a(4)-a(3)),'k');
    end
  end
  xlabel 'Time (ms)'
  ylabel 'V (a.u.)'
  
  if opts.outliers
    % Hand draw outliers
    idx = find(asg==0);
    wv = spikes.waveforms(idx,:);
    T = size(wv,2);
    if ~isempty(opts.oversamp)
      tinterp = [1:1/opts.oversamp:T];
      wv = interp1([1:T]',wv',tinterp, 'spline')';
      tt = [1:1/opts.oversamp:T];
    else
      tt = [1:T];
    end
    tt = (tt-spikes.threshT) * 1000/spikes.Fs;
    plot(tt, wv, 'color', [.75 .75 .75]);
    a=axis;
    text(0, a(3)+.1*(a(4)-a(3)), ...
	sprintf('0: %i',length(find(asg==0))), ...
	'horizontalalignment', 'left', ...
	'verticalalignment', 'middle', ...
	'color', 'k', ...
	'fontsize', 14, ...
	'fontweight', 'bold');  
  end
  
  if opts.centroids
    for n=1:N
      if ~isempty(centroids{n})
	tt=([1:length(centroids{n})]-spikes.threshT) * 1000/spikes.Fs;
	plot(tt, centroids{n}, 'color', 1-cc(renum(n)+1,:));
      end
    end
  end
  
  if cls
    % Add text labels
    tind = ([1:size(wv,2)]-spikes.threshT) * 1000/spikes.Fs;
    a=axis;
    for dx=[-1 1 0]
      for dy=[-1 1 0]
        for n=1:N
  	if dx==0 & dy==0
  	  clr='k';
  	else
  	  clr='w';
  	end
  	dx1 = .001*(a(2)-a(1)) * dx;
  	dy1 = .001*(a(4)-a(3)) * dy;
  	text(tind(pki(n))+dx1, pky(n)+dy1, ...
  	    sprintf('%i: %i',renum(n),length(find(newasg==n))), ...
  	    'horizontalalignment', 'left', ...
  	    'verticalalignment', 'middle', ...
  	    'color', clr);
  	text(tind(vli(n))+dx1, vly(n)+dy1, ...
  	    sprintf('%i',renum(n)), ...
  	    'horizontalalignment', 'left', ...
  	    'verticalalignment', 'middle', ...
  	    'color', clr);
        end
      end
    end
  end
  setappdata(gca, 'colormap', 1-cc);
  clear
end
