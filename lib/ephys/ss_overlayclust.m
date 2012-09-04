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
%      fourier: flag to make oversamp use UPSAMPLE rather than spline
%               interpolation
%      cmap: map of colors to use. The first is used for outliers (if plotted),
%            the rest for the selected clusters.
%      maxplot: no more than this number of traces will be used per cluster.
%               If there are more traces than this, a random selection will
%               be made. Default: maxplot=10000.
%    [img, tind, yind] = SS_OVERLAYCLUST(...) returns image and coordinates
%    rather than plotting it. TIND is in milliseconds, yind in data units.
%    [img, tind, yind, cmap] = ... also returns the actually used color map.

opts = getopt('oversamp ybins=100 outliers=0 selection darker=0 cmap centroids=0 marksamples=0 fourier=0 maxplot=10000', varargin);

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
if isempty(opts.selection)
  yy = hist(asg,[0:N]);
  yy(1) = 0; % don't include outliers as a regular cluster
else
  yy = zeros(1,N+1);
  yy(opts.selection+1) = 1;
end
renum = find(yy>0) - 1;
asgmap = cumsum(yy>0);
asgmap(yy==0)=0;
newasg = asgmap(asg+1); % This starts at 1 for clusters with yy>0, which
% may include the outlier cluster if explicitly selected.
% newasg=0 for ignored clusters.
N = max(newasg);

y0 = zeros(N,1);
for n=1:N
  idx = find(newasg==n);
  if ~isempty(idx)
    y0(n) = mean(max((spikes.waveforms(idx,:)),[],2));
  end
end
[dd,ord] = sort(y0); 

if isempty(opts.selection)
  plotord = renum(ord);
else
  plotord = opts.selection;
end

if isempty(opts.cmap)
  cc = jet(1024);
  if cls
    ord(ord)=1:N;
    cc = cc(1+mod(650*ord,1024),:);
  else
    cc = cc(round(1+[0:N-1]*1023/(N-1)),:);
  end
  cc = [[.75 .75 .75]; cc];
else
  cc = opts.cmap;
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
  if length(idx)>opts.maxplot
    sel = randperm(length(idx));
    idx = idx(sel(1:opts.maxplot));
    clear sel
  end
  wv = spikes.waveforms(idx,:);
  wv0 = mean(wv);
  centroids{n} = wv0;
  [pky(n),pki(n)] = max(wv0);
  [vly(n),vli(n)] = min(wv0);
  if ~isempty(opts.oversamp)
    if opts.fourier
      wv = upsample(wv', opts.oversamp)';
    else
      T = size(wv,2);
      tinterp = [1:1/opts.oversamp:T];
      wv = interp1([1:T]',wv',tinterp, 'spline')';
    end
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
aimg = zeros(Y*X,3) + 1;
mxint = max(mxintens);
for m=plotord(:)'
  n = asgmap(m+1);
  im = img{n}(:);
  im = im/mxintens(n);
  if opts.darker>1
    im = im*opts.darker;
    im(im>1) = 1;
  end
  for k=1:3
    aimg(:,k) = (1-im).*aimg(:,k) + im.*cc(n+1,k);
  end
end
aimg = reshape(aimg, [Y,X,3]);

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
    plot(tt, wv, 'color', cc(1,:));
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
    for m=plotord(:)'
      n = asgmap(m);
      if n>0 && ~isempty(centroids{n})
	tt=([1:length(centroids{n})]-spikes.threshT) * 1000/spikes.Fs;
	plot(tt, centroids{n}, 'color', cc(n,:));
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
  setappdata(gca, 'colormap', cc);
  clear
end

cmap = cc;
