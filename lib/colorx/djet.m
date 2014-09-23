function cc = djet(N)
% DJET - Like JET, but better sampling for small N
%    cc = DJET(n) returns a JET color map with N entries.
cc = jet(100*N-99);
cc = cc(1:100:end,:);
