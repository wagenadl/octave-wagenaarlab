function xx = normalizemeasignal(xx, dy)
% NORMALIZEMEASIGNAL - Scales MEA recording by estimated RMS noise
%    yy = NORMALIZEMEASIGNAL(xx) estimates the RMS noise in the 
%    signal XX and returns a normalized vsn of the data.
%    yy = NORMALIZEMEASIGNAL(xx, dy) also adds an offset to each
%    channel's data.

if nargin<2
  dy = 0;
end


[T N] = size(xx);
D = 25*10; % 10 ms
K = floor(T/D);
zz = reshape(xx(1:K*D,:),[D K N]);
zz = squeeze(std(zz));
zz = median(zz);
for n=1:N
  xx(:,n) = (xx(:,n) - mean(xx(:,n))) ./ zz(n) + dy*(n-1); 
end
