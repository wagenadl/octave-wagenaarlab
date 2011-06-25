function scatterspks(y)
% SCATTERSPKS(y) plots the spike data in y (loaded via loadspks) on
% channel vs time plot. Time is in seconds, no binning is attempted

plot(y.time,y.channel,'.');
