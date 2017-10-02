function bdvsibi(dat)
% BDVSIBI(dat) plots the burst duration against the preceding interburst 
% interval using the data given.
% dat must be Nx4:
% column 1: burst arrival times
% column 2: burst duration
% column 3: raw burst strength
% column 4: scaled burst strength
% These data are normally obtained using findburst (meabench/perl).
sh=shift(dat,1);
dt=sh(:,1)-dat(:,1);
n=length(dt);
plot(dt(1:(n-1)), dat(2:n,2), '.');
%xlabel('ibi (s)');
%ylabel('bd (s)');