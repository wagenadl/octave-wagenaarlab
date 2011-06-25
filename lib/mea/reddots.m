function pp=reddots(latency,trial,bid,maxlat,maxtri,clr)
% REDDOTS(latency,trial,bid,maxlat,maxtri,clr) plots a red-dot graph 
% given latency (ms), trial number and burst ID data.
% MAXLAT and MAXTRI are optional - they default to the max. observed
% latency and trial
% CLR is optional: it may be a 2 char string replacing default blue and red.
% Return value is array of plot handles.

ii=find(bid>0);
jj=find(bid==0);
rnd1=rand(size(latency))/25;
rnd2=rand(size(trial));

if nargin<5 | isempty(maxtri)
  maxtri = max(trial)+1;
end
if nargin<4 | isempty(maxlat)
  maxlat = max(latency);
end
if nargin<6 | isempty(clr)
  clr='br';
end

pp=zeros(1,2);

k=ishold;
if ~isempty(jj)
  pp(1)=plot(latency(jj)+rnd1(jj),trial(jj)+rnd2(jj),[clr(1) '.'],'markersize',1);
  hold on
end
if ~isempty(ii)
  pp(2)=plot(latency(ii)+rnd1(ii),trial(ii)+rnd2(ii),[clr(2) '.'],'markersize',1);
end
axis([0 maxlat 0 maxtri]);
xlabel 'Latency (ms)'
ylabel 'Trial number'
title 'Red dots!'
if ~k
  hold off
end
