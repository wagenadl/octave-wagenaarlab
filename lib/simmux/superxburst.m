function ss=superxburst(mm,kk,nestthr,usemon)
% ss=SUPERXBURST(mm,kk) finds the superbursts in a set of multix
% bursts.
% A superburst is a train of big bursts surrounded by a lack of big
% bursts. More precisely, a superburst is a train of bursts with no
% interval longer than 3x the mean of the earlier intervals within
% the superburst, and with intervals before and after the last
% constituent which are 3x larger than the mean internal interval.
%
% Return: a structure with members:
%
%  Sx1  ONSET:   onset of first multix in superburst
%  Sx1  OFFSET:  offset of last multix in superburst
%  Sx1  NSUB:    number of multices
%  Sx1  NETSPKS: total number of spikes
%  Sx1  TOTDUR:  sum of constituent durations
% {Sx1} CONSTIT: list of constituent multices
%
% MM must be the return of MULTIXBURST, KK must be from BIGXBURST. 
% If KK is not given, BIGXBURST is called internally.
% By default, this fn is not smart about "nesting" superbursts: 
% If a burst train looks like this:
%
%     |                  |||   |||  |||   |                |         |
%   
%                        -!-   -2-  -3-
%                        -1----------------
%
% it will return three superbursts, as shown by the numbered dotted
% lines. Note that -!- is *not* detected.
% A third argument, NESTTHR, can be given to prevent this: 1. Any
% superburst candidate with longest internal IBI larger than NESTTHR is
% dropped. 2. Any superburst that is nested inside another one is
% dropped. This doesn't solve the missing of -!-.


if nargin<2 | isempty(kk)
  kk=bigxburst(mm);
end
kk=kk(:);

if nargin<3 | isempty(nestthr)
  nestthr=0;
end

if nargin<4 | isempty(usemon)
  usemon=0;
end

if usemon==1
  mm.onset=mm.monset;
  mm.offset=mm.moffset;
elseif usemon==2
  mm.onset=mm.qonset;
  mm.offset=mm.qoffset;
end

ss.onset=[];
ss.offset=[];
ss.nsub=[];
ss.netspks=[];
ss.totdur=[];
ss.constit={};

thrfact=3;

ibi = [mm.onset(kk); inf] - [-inf; mm.offset(kk)]; % ibi(m) precedes burst m

M=length(kk);
s=1;
mmin=0;
for m=1:M-1
  if ibi(m+1)<=ibi(m)/3 & m>=mmin
    % Candidate!
    e=m+1;
    while e<M & ibi(e+1)<=3*mean(ibi(m+1:e)) %ibi(m)/3
      e=e+1;
    end
    avg=mean(ibi(m+1:e));
    mx=max(ibi(m+1:e));
    if ibi(e+1)>=3*avg & ibi(m)>=3*avg
      % Good candidate!
      if nestthr>0 & mx>nestthr
	% But not good enough
	continue
      end
      ss.onset(s) = mm.onset(kk(m));
      ss.offset(s) = mm.offset(kk(e));
      ss.nsub(s) = e+1-m;
      ss.netspks(s) = sum(mm.netspks(kk(m:e)));
      ss.totdur(s) = sum(mm.offset(kk(m:e))-mm.onset(kk(m:e)));
      ss.constit{s} = kk(m:e);
      s=s+1;
      if nestthr>0
	mmin=e+1;
      end
    end
  end
end
