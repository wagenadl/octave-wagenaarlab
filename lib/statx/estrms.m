function rms = estrms(yy, binw, prc)
% ESTRMS - Estimate RMS noise from electrode data with spikes
%   rms = ESTRMS(yy, binw) divides the data YY into bins of BINW samples,
%   calculates the RMS in each, and returns the median of those RMS values.
%   rms = ESTRMS(yy, binw, prc) returns the PRC-th percentile.
%   If PRC==0, all RMS values are returned.

if nargin<3
  prc=.5;
end

L=length(yy);
N=floor(L/binw);
rms = std(reshape(yy(1:N*binw),[binw N]));
if prc>0
  rms = sort(rms);
  rms = rms(ceil(prc/100*N));
end
