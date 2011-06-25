function dmu = anova1_bonferroni(a,kk,p)
% ANOVA1_BONFERRONI - Bonferroni-corrected multiple comparisons after ANOVA
%    dmu = ANOVA1_BONFERRONI(a,kk,p) performs multiple comparisons between
%    several treatments in the ANOVA1 dataset A. The array KK (Cx2) specifes
%    which C comparisons are performed.
%    dmu (Cx2) returns the confidence intervals of the comparisons at the
%    confidence level (1-P).

C=size(kk,1);
dmu0 = zeros(C,1);
ddmu = zeros(C,1);

load ttable.mat;
ip=find(pp<=p/(2*C));
if isempty(ip)
  ddmu=ddmu+inf;
else
  ip=ip(1);
  for c=1:C
    dmu0(c) = a.data.avg(kk(c,1))-a.data.avg(kk(c,2));
    df = a.DFE;
    if df>100
      t = tinf(ip);
    else
      t = tt(df,ip);
    end
    ddmu(c) = t * sqrt(a.MSE*sum(1/a.data.nnn(kk(c,:))));
  end
end
dmu = [dmu0-ddmu dmu0+ddmu];
