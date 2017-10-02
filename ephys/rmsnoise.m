function sig = rmsnoise(tt, yy, varargin)
% RMSNOISE - Estimate RMS noise from a spiky signal
%    sig = RMSNOISE(tt, yy), where YY is an extracellular recording
%    sampled at times TT (in seconds), splits the signal into (10-ms) bins
%    and uses these to estimate the RMS noise.
%    sig = RMSNOISE(yy, tt) or sig = RMSNOISE(yy, fs_Hz) also work.
%    sig = RMSNOISE(..., key, value, ...) specifies additional parameters:
%       dt_win: window length, in milliseconds. Default: 10.
%
%    We do this by taking the 20th percentile of the collected RMS values
%    in the small windows, and dividing that number by the 20th percentile
%    of RMS values from same-sized windows from Gaussian noise. This ends
%    up being a fairly robust estimate that is not easily perturbed by the
%    presence of spikes.
%    Caution: do not use windows that are longer than 1/f_low, where f_low
%    is the low frequency cutoff of the recording bandpass filter.

[tt, yy, f_hz] = normalizespikedetargs(tt, yy);

kv = getopt('dt_win=10', varargin);

L = length(yy);
K = round(1e-3*kv.dt_win * f_hz);
N = floor(L/K);

F = 0.2;

yy = reshape(yy(1:N*K),[K N]);
yy = std(yy);
yy = nth_element(yy, ceil(F*N));

if 0
  % Let's find out what a normal distribution would do
  kk = 2.^[5:.5:10];
  M = 10000;
  for k=1:length(kk)
    K = kk(k);
    rnd = randn(K, M);
    rnd = std(rnd);  
    rnd = nth_element(rnd, ceil(F*M));
    rn(k) = rnd;
  end
  plot(log(kk), log(1-rn));
  p = physfit('linear', log(kk), log(1-rn));
  % Best fit is log(1-rnd) = -.5259*log(K) - .3317,
  % in other words:
  %    rnd = 1 - exp(-.5259*log(K) - .3317).
  % This is all for F = 0.2.
else
  rnd = 1 - exp(-.5259*log(K) - .3317);
end

sig = yy/rnd;
