function [rho,xi0]=quantifyorder(X)
% [rho,xi0]=QUANTIFYORDER(X) computes the orderedness of the NxD matrix X.
% That is, it sorts the rows of X and measures to what extent all
% rows are ordered in the same way.
% rho will be a vector of numbers between 0 and 1, with 1 signifying
% that the corresponding channel is always in the exact same
% position, and 0 signifying that the channel is in random
% positions.
%
% This code ignores the finite size correction: I am assuming that
% mean((2*[0:D1]/D1-1).^2) == 1/3. In fact, for D1=59, the true
% answer is 0.3446. Thus, fully random input actually results in a
% number slightly less than zero.
%
% Output argument xi0 receives the average order of each channel, nan 
% for totally bad channels.

[N D]=size(X);
bad=isnan(X);
X(bad)=inf; % Make sure bad channels end up sorted last.
dgood=sum(~bad,2); % # of good channels per trial
[dummy, x_ord] = sort(X,2);

epsilon=1e-10;

xi=zeros(N,D);
for n=1:N
  x(x_ord(n,:))=[1:D];
  dgood(dgood<=1)=1;
  xi(n,:)=2*(x-1)/(dgood(n)-1+epsilon) - 1;
end
good=xi<=1;
xi(~good)=0;
xi0 = sum(xi,1) ./ (sum(good,1)+epsilon);

dxi2 = (xi - repmat(xi0,[N 1])).^2;
dxi2(~good)=0;
dxi20 = sum(dxi2,1) ./ (sum(good)+epsilon);

rho = 1 - dxi20./(1/3);
cgood=sum(~bad,1)>0;
rho(~cgood)=nan;
xi0(~cgood)=nan;
