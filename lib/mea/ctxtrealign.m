function[ctxt,badidx]=ctxtrealign(context)
% ctxt=CTXTREALIGN(context) returns realigned contexts,
% which must have been loaded by loadspks or equiv. The contexts are
% first upsampled, then shifted, then downsampled again.
% Upsample ratio is 4. Only the first 64 context values are used.
% Result is cut by upto MAXSHIFT samples on either end, for a total new width
% of 256-2*MAXSHIFT samples with the peak at 100-MAXSHIFT.
% The peak position is found by weighting |y|^2 in the central region,
% where the central region is defined as the portion of the waveform
% that's >.5*peak.
% This function differs from ctxtupsample as follows:
% 1. It downsamples the contexts back to original frequency after alignment.
% 2. It expects spks.context argument, rather than spks.
% 3. By writing [ctxt,badidx]=CTXTREALIGN(...), the indices of non-alignable
%    spikes can be obtained as well.

badidx=zeros(1,0);
N=size(context,2);
cf = fft(context(1:64,:));
ctx4 = 4*real(ifft(cat(1,cf(1:32,:),zeros(192,N),cf(33:64,:))));
pseudopeak = ctx4(100,:);
MAXSHIFT=12;
pks=zeros(N,1);
for n=1:N
  iin=100;
  thr = pseudopeak(n) * .5;
  while ctx4(iin,n) < thr & iin>1
    iin = iin-1;
  end
  iout=100;
  while ctx4(iout,n) < thr & iout<200
    iout = iout+1;
  end
  idx=[iin:iout];
  xx=ctx4(idx,n).^2;
  ipeak = sum(xx.*idx')/sum(xx) - 101;
  pks(n)=ipeak;
  if abs(ipeak)>=MAXSHIFT
    badidx=cat(2,badidx,n);
%    fprintf(2, ...
%	 'Warning: peak for spike %i out of range (%g) - not shifting\n',  ...
%	 n,ipeak);
    ipeak=0;
  end
  ifloor = floor(ipeak);
  ifrac = ipeak - ifloor;
  fltb = cat(1,zeros(MAXSHIFT-ifloor,1), ifrac, 1-ifrac, ...
      zeros(MAXSHIFT+ifloor,1));
  flta = zeros(length(fltb),1); flta(1)=1;
  ctx4(:,n) = filter(fltb,flta,ctx4(:,n));
end
hist(pks,100);
ctxt = ctx4((MAXSHIFT*2+1):4:256,:);
