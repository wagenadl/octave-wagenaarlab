function c = SS_CONFUSION(cls1, cls2)
% SS_CONFUSION - Confusion between two cluster assignments
%    c = SS_CONFUSION(cls1, cls2) calculates the confusion between clusters:
%    For each integer value that occurs in CLS1, we find out the most common
%    correspondence in CLS2, and treat all other matches as a confusion.
%    C will be a structure with fields:
%      iconf: a column vector with confusion values for each value in CLS1.
%      ilabel: corresponding values in CLS1.
%      avg: average of the values in INDIV weighed by cluster size
%      raw: raw confusion matrix
%      jlabel: labels for the rows of RAW
%      icount: column vector of counts in CLS1
%      jcount: row vector of counts in CLS2

mn1 = min(cls1);
mx1 = max(cls1);

mn2 = min(cls2);
mx2 = max(cls2);

M1 = 1 + mx1 - mn1;
M2 = 1 + mx2 - mn2;

c.iconf = zeros(M1,1);
c.ilabel = [mn1:mx1]';
c.icounts = zeros(M1,1);
c.jlabel = [mn2:mx2];
c.jcounts = zeros(1,M2);
c.raw = zeros(M1,M2);
c.avg = [];

for m = 1:M1
  idx = find(cls1==m + mn1-1);
  c.icounts(m) = length(idx);
  cc2 = cls2(idx);
  hh = hist(cc2,[mn2:mx2]);
  c.jcounts = c.jcounts + hh;
  hh = hh/sum(hh);
  h1 = max(hh);
  c.raw(m,:) = hh;
  c.iconf(m) = 1-h1;
end
use = find(c.icounts>0);
c.avg = sum(c.iconf(use).*c.icounts(use))/sum(c.icounts);

if nargout==0
  bar([0:length(use)], [c.avg; c.iconf(use)]);
  set(gca,'xtick',[0:length(use)], 'xticklabel',[-1 c.ilabel(use)']);
  axis tight
  a=axis;
  text(0,c.avg+a(4)*.01,sprintf('%i',sum(c.icounts)),'rota',90);
  for k=1:length(use)
    text(k,c.iconf(use(k))+a(4)*.01,sprintf('%i',c.icounts(use(k))),'rota',90);
  end
  autoextend
  clear
end
