function plotpeaks(p,mu,sigma,x,t,r)
% PLOTPEAKS(p,mu,sigma,x) visualizes the result of FINDPEAKS.
% p,mu,sigma must be the result of FINDPEAKS, called with data
% argument x.
% Optional fifth argument t specifies the x-axis labeling.
% Optional sixth argument r specifies residuals to be bar graphed on
% top of the data graph.

K=length(p);
N=length(x);
tt=[1:N];
if nargin<5
  t=tt;
end
if isempty(t)
  t=tt;
end

b=bar(t,x,1);
set(b,'FaceColor',[.6 .6 .6]);
set(b,'EdgeColor',[.6 .6 .6]);
hold on

if nargin>=6
  b=bar(t,r,1);
  set(b,'FaceColor',[.2 .2 .2]);
  set(b,'EdgeColor',[.2 .2 .2]);
end

cols=[1 0 0; 0 .4 0; 0 0 1; .3 .3 0; 0 .3 .7; 1 0 1];

for k=1:K
  a=plot(t,normpdf(tt,mu(k),sigma(k))*p(k),'-');
  set(a,'Color',cols(1+mod(k-1,length(cols)),:));
  tx=text(t(ceil(mu(k))),p(k)/sqrt(2*pi*sigma(k).^2),sprintf('%.0f',p(k)));
  set(tx,'HorizontalAlignment','Center');
  set(tx,'VerticalAlignment','Bottom');
%  tx=text(t(ceil(mu(k))),0,sprintf('|%.0f|',p(k)));
%  set(tx,'HorizontalAlignment','Center');
%  set(tx,'VerticalAlignment','Top');
end
hold off
