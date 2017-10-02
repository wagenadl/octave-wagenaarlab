function [b,a] = highpass1(wn)
% [b,a] = HIGHPASS1(wn) creates a first order high-pass filter, with 
% cutoff at WN. (WN=1 corresponds to the sample frequency, not half!)

[b,a]=butterhigh1(wn);

%tau = 1/(2*pi*wn);
%
%a = [1,1/tau-1];
%%b = [1,-1];
%b=[1,-1]*(1-1/tau/2);
