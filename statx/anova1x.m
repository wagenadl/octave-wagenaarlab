function a = anova1(xx,quiet)
% ANOVA1 - One-way ANOVA
%    a = ANOVA1(xx) computes one-way ANOVA on the data XX.
%    The data must be a cell array, one cell per treatment.
%    NB: There is no assumption of pairing in ANOVA; the number of data
%    per cell do not have to be equal.
%    anova1(xx,1) does not print a table.

% This is based on section 7.4.3.1 of the NIST Statistics handbook

if nargin<2
  quiet=0;
end

k=length(xx);
avg = zeros(k,1);
nnn = zeros(k,1);
sse = zeros(k,1);

for n=1:k
  avg(n) = mean(xx{n});
  nnn(n) = length(xx{n});
  sse(n) = sum((xx{n}-avg(n)).^2);
end

grandavg = sum(avg.*nnn)./sum(nnn);

SST = sum(nnn.*(avg-grandavg).^2);
SSE = sum(sse);
SS = SST+SSE;
NNN = sum(nnn);
DFT = k-1;
DFE = NNN-k;

MST = SST/DFT;
MSE = SSE/DFE;

F = MST/MSE;

p=1-fcdf(F,DFT,DFE);

a.table{1} = sprintf('%12s %8s %8s %8s %8s %8s','Source','SS','DF','MS','F','p <');
a.table{2} = sprintf('%12s %8.3f %8i %8.3f %8.3f %8.4g','Treatments',SST,DFT,MST,F,p);
a.table{3} = sprintf('%12s %8.3f %8i %8.3f','Random',SSE,DFE,MSE);
a.table{4} = sprintf('%12s %8.3f %8i','Total (cor.)',SS,NNN-1);

if ~quiet
  fprintf(1,'%s\n',a.table{:});
end

a.data.xx = xx;
a.data.nnn = nnn;
a.data.avg = avg;

a.SST=SST;
a.SSE=SSE;
a.DFT=DFT;
a.DFE=DFE;
a.MST=MST;
a.MSE=MSE;
a.F=F;
a.SS=SS;
a.NNN=NNN;
a.DF=NNN-1;
a.p=p;
