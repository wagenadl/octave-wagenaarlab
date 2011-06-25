function [p,mu,sigma,x]=findpeaks(x, p_min, lim, zerowidth)
% [p,mu,sigma,r]=FINDPEAKS(x,p_min) returns all peaks with p-value at
% least p_min in vectors p, mu, sigma. It works by repeatedly calling
% findapeak and blanking out the region of the peak.
% Optional third argument is "lim" for findapeak.
% Optional fourth argument specifies the extent of blanking in units
% of sigma for each individual peak, default is 2.
% The results can be visualized using PLOTPEAKS.
% The residuals are returned in r.
% Reasonable values for p_min are 0.01*sum(x) or
% 0.05*number of trials, or some similar measure.

if nargin<3
  lim=[];
end
if nargin<4
  zerowidth=2;
end
if isempty(zerowidth)
  zerowidth=2;
end

t=[1:length(x)];

p=zeros(0,1); mu=zeros(0,1); sigma=zeros(0,1);
while 1
  [P,MU,SIGMA] = findapeak(x, lim);
  if P<p_min % or set threshold at p_min*.3 or something to be less peak dep.
    return;
  end
  if P>=p_min
    p=cat(1,p,P);
    mu=cat(1,mu,MU);
    sigma=cat(1,sigma,SIGMA);
  end
%  clf
%  bar(x);
%  hold on;
%  plot(t,normpdf(t,MU,SIGMA)*P,'r-');
%  b=bar(x-normpdf(t,MU,SIGMA)*P);
%  set(b,'FaceColor',[0 1 0]);
%  hold off;
%  axis([MU-15*SIGMA MU+15*SIGMA 0 120]);

  x = x - normpdf(t,MU,SIGMA)*P;
  cl0=max([1 ceil(MU-SIGMA*zerowidth)]);
  cl1=min([length(x) floor(MU+SIGMA*zerowidth)]);
  x(cl0:cl1)=0;
  x(find(x<0))=0;
%  pause
end
