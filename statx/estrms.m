function [rms, ii, wrms] = estrms(yy, binw, prc)
% ESTRMS - Estimate RMS noise from electrode data with spikes
%   rms = ESTRMS(yy, binw) divides the data YY into bins of BINW samples,
%   calculates the RMS in each, and returns the median of those RMS values.
%   rms = ESTRMS(yy, binw, prc) returns the PRC-th percentile.
%   If PRC==0, all RMS values are returned.
%   [rms, ii] = ESTRMS(...) returns the start indices of the windows as well.
%   [rms, ii, wrms] = ESTRMS(...) returns the RMS in each window as well.

if nargin<2
  binw = 250;
end
if nargin<3
  prc=50;
end

L=length(yy);
N=floor(L/binw);
rms = std(reshape(yy(1:N*binw),[binw N]));

if nargout>=3
  wrms = rms;
end

if prc>0
  rms = sort(rms);
  rms = rms(ceil(prc/100*N));
end

if nargout>=2
  ii = [0:N-1]*binw + 1;
end
