function bsvsbd(dat)
% BSVSBD(dat) plots the burst strength against the burst duration
% using the data given.
% dat must be Nx4:
% column 1: burst arrival times
% column 2: burst duration
% column 3: raw burst strength
% column 4: scaled burst strength
% These data are normally obtained using findburst (meabench/perl).
plot(dat(:,2), dat(:,3), '.');
%xlabel('bd (s)');
%ylabel('bs (s^{-1})');