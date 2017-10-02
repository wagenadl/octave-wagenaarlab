function [b,a] = lowpass1(wn)
% [b,a] = LOWPASS1(wn) creates a first order low-pass filter, with 
% cutoff at WN. (WN=1 corresponds to the sample frequency, not half!)

[b,a] = butterlow1(wn);

%tau = 1/(2*pi*wn);
%
%a = [1,1/tau-1];
%b = [1/tau,0];
