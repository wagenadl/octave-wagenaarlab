function y = mosg_merits(X,par)
% MOSG_MERITS returns sorted lists of split and merge candidates.
% Input: X, par as per mosg_fullem
% Output: structure with members
%    Jsplit: Kx2 matrix of [merit; clusterno] rows
%    Jmerge: (K*(K-1)/2)x3 matrix of [merit, clusterno_1, clusterno_2] rows
% By definition clusterno_1 < clusterno_2 for all reported
% candidates.
% Note that split and merge merits cannot be usefully added
% directly: they are unfortunately defined on different scales.

K=size(par.p,2);

R = mosg_responsibility(X,par);

Jm = mosg_mergemerit(X,par,R);
Jsplit = mosg_splitmerit(X,par,R);

Jmerge = zeros(K*(K-1)/2,3);
idx = 1;
for k=1:K
  for l=(k+1):K
    Jmerge(idx,:) = [ Jm(k,l), k, l ];
    idx = idx + 1;
  end
end

Jsplit = cat(2,Jsplit,[1:K]');

[dummy, idx] = sort(-Jmerge(:,1));
y.Jmerge = Jmerge(idx,:);
[dummy, idx] = sort(-Jsplit(:,1));
y.Jsplit = Jsplit(idx,:);
