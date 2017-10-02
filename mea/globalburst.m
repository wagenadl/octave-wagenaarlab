function [bursts,burstid,yy]=globalburst(times, channels, mthr, thr1, thr0, wid, div)
% bursts = GLOBALBURST(times, channels, mthr, thr1, thr0, wid, div) 
% detects global bursts in the given spike data.
% Input:
%   TIMES is in seconds
%   CHANNELS is channel number, counting from 0.
%   MTHR is threshold for local bursts, as a multiple of mean firing rate
%   THR1, THR0 are thresholds for entering and exiting global bursts, in
%   terms of number of channels.
%   WID is the window size (in seconds).
%   DIV is the over-sampling factor.
%
% All but TIMES and CHANNELS are optional.
%
% Output: A structure with members:
%   ONSET, OFFSET: burst start and end times (s)
%   MAXCC: max number of channels simultaneously active
%   ENVCC: envelope of active channels in a burst
%   SPKCNT: spike count in each burst
%   MTHR, THR1, THR0, WID, DIV: as on input, or default values used.
%   TT, CC: Times and values for channel count histogram, see below.
% Optional second output element BURSTID catches the burst numbers for every
% spike in TIMES, 0 indicating 'not in burst'.
%
% Algorithm: 
% - For each channel, bin the spikes into bins of size WID/DIV. 
% - Calculate the average firing rate for each channel, and flag those bins
%   in which a given channel exceeds its average by a factor MTHR.
% - For each timebin, calculate the number of channels so flagged. Smooth
%   the result using GAUSSIANBLUR1D, with SIGMA=DIV/2.
%   (This is CC).
% - Find those bins where CC first exceeds THR1. These are the burst onsets.
% - Find those bins where CC first drops below THR0. These are the offsets.
% - Output values ONSET and OFFSET are always in seconds, not bin numbers.
%
% The output is suitable for feeding to BURSTID. You may wish to expand
% ONSET and OFFSET by ~100 ms to fully capture the start and
% end of bursts.

if nargin<3 | isempty(mthr)
  mthr = 3;
end

if nargin<4 | isempty(thr1)
  thr1 = 10;
end

if nargin<5 | isempty(thr0)
  thr0 = 2;
end

if nargin<6 | isempty(wid)
  wid = 0.050;
end

if nargin<7 | isempty(div)
  div = 2;
end

bursts.mthr = mthr;
bursts.thr1 = thr1;
bursts.thr0 = thr0;
bursts.wid  = wid;
bursts.div  = div;

times=times(:);
channels=channels(:);

dt = wid/div;
tt=[min(times)-dt/2:dt:max(times)+dt/2];
T=length(tt);
C=max(channels)+1; 
if C<=64
  C=60;
  idx=channels<C; 
  times=times(idx); 
  channels=channels(idx);
end

yy=zeros(C,T);
for c=1:C
  yy(c,:)=hist(times(find(channels==c-1)),tt);
end

if isempty(yy)
  bursts.onset=[];
  bursts.offset=[];
  bursts.stddur=[];
  burstid=[];
  bursts.maxcc=[];
  bursts.envcc=[];
  bursts.spkcnt=[];
  bursts.chmap=[];
  bursts.chcnt=[];
  bursts.meant=[];
  return
end

if length(mthr)==1
  mm=mean(yy');
  mthr=mthr*mm;
end
bursts.mthr=mthr;
zz = yy > repmat(mthr(:),[1,T]);
cc = gaussianblur1d(sum(zz),div/2);

onset=[];
offset=[];
stddur=[];
maxcc=[];
envcc=[];
spkcnt=[];
chmap=[];
chcnt=[];
meant=[];

x0=1;
if nargout>1
  burstid=zeros(1,length(times));
end
n=0;
while x0<T
  n=n+1;
  xi = find(cc(x0+1:end)>thr1);
  if isempty(xi)
    break
  end
  x1=x0+min(xi);
  xi = find(cc(x1+1:end)<thr0);
  if isempty(xi)
    x2=T;
  else
    x2 = x1+min(xi);
  end
  onset=[onset tt(x1)];
  offset=[offset tt(x2)];
  maxcc=[maxcc max(cc(x1:x2))];
  ezz=sum(zz(:,x1:x2),2);
  chm=ezz>0;
  envcc=[envcc sum(chm)];
  chmap=[chmap, chm];
  idx = find(times>=tt(x1)-wid & times<tt(x2)+wid);
  chcnt=[chcnt, hist(channels(idx),[0:59])'];
  stddur = [ stddur std(times(idx))];
  meant = [ meant mean(times(idx(find(chm(channels(idx)+1))))) ];
  spkcnt = [ spkcnt length(idx)];
  if nargout>1
    burstid(idx) = n;
  end
  x0=x2;
end
  
bursts.onset=onset;
bursts.offset=offset;
bursts.tt = tt;
bursts.cc = cc;
bursts.maxcc = maxcc;
bursts.envcc = envcc;
bursts.spkcnt = spkcnt;
bursts.chcnt = chcnt;
bursts.chmap = chmap;
bursts.netcnt = sum(chcnt.*chmap);
bursts.bestcnt = max(chcnt.*chmap);
bursts.stddur = stddur;
bursts.meant = meant;
