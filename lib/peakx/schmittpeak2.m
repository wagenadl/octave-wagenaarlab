function [ipk, on_a,off_a,on_b,off_b] = schmittpeak2(xx,thr_a,thr_b)
% SCHMITTPEAK2 - Double Schmitt triggering with peak reporting
%   [ipk, on_a, off_a, on_b, off_b] = SCHMITTPEAK2(xx, thr_a, thr_b)
%   is just like SCHMITTPEAK2, except that it also returns the index
%   of the highest point in each peak.

[on_a,off_a,on_b,off_b] = schmitt2(xx,thr_a,thr_b);

K = length(on_a);
ipk=zeros(K,1);
for k=1:K
  ipk(k) = argmax(xx(on_a(k):off_a(k))) + on_a(k)-1;
end
