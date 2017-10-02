function spks1=sorttrialbycount(spks0)
% spks1=SORTTRIALBYCOUNT(spks0) takes a matrix intended for hist60log
% and friends, and changes column 5 to spike count order, highest
% counts plotted near top of graph.
% This is useful for checking whether presence of burst is predicted
% by early pattern.

ntrials=max(spiks0(:,5));
tricnt=hist(spks0(:,5),ntrials);
[y x]=sort(tricnt);
xinv=zeros(1,ntrials); for i=1:trials, xinv(x(i))=i; end
spks1=spks0;
spks1(:,5)=xinv(spks0(:,5));

