function an = anova2(xx)
% ANOVA2 - Two-way ANOVA
%    a = ANOVA2(xx) computes two-way ANOVA on the data XX.
%    The data must be a cell array, one cell per treatment. XX{a,b} 
%    contains data from level a of factor A, level b of factor B.

% This is based on section 7.4.3.7 of the NIST Statistics handbook. 
% Notation: XX = XX{i,j}(k) is datum k of level i of factor A, 
% level k of factor B.

[a b]=size(xx);
avg = zeros(a,b);
nnn = zeros(a,b);
sse = zeros(a,b);
for i=1:a
  for j=1:b
    nnn(i,j) = length(xx{i,j});
    avg(i,j) = mean(xx{i,j});
    sse(i,j) = sum((xx{i,j} - avg(i,j)).^2);
  end
end
avgj = sum(nnn.*avg,1)./sum(nnn,1);
avgi = sum(nnn.*avg,2)./sum(nnn,2);
grandavg = sum(nnn(:).*avg(:)) ./ sum(nnn(:));

N = sum(nnn(:));

if 0
  % This is what is actually in the handbook, requires same number of
  % data in each treatment.
  if any(nnn ~= nnn(1,1))
    error('ANOVA2 requires same number of data in each cell');
  end
  
  r = nnn(1,1);
  
  SS_A = r*b*sum((avgi-grandavg).^2);
  SS_B = r*a*sum((avgj-grandavg).^2);
  SS_AB = r*sum(sum((avg - repmat(avgi,[1 b]) - repmat(avgj,[a 1]) + grandavg).^2));
else
  % More general version, does not require same number of data in
  % each treatment.
  SS_A = sum(sum(nnn.*(repmat(avgi,[1 b])-grandavg).^2));
  SS_B = sum(sum(nnn.*(repmat(avgj,[a 1])-grandavg).^2));
  SS_AB = sum(sum(nnn.*(avg - repmat(avgi,[1 b]) - repmat(avgj,[a 1]) + grandavg).^2));
end

SSE = sum(sse(:));
SS = SS_A+SS_B+SS_AB+SSE;

DF_A = a-1;
DF_B = b-1;
DF_AB = (a-1)*(b-1);
DFE = N-a*b;

MS_A = SS_A / DF_A;
MS_B = SS_B / DF_B;
MS_AB = SS_AB / DF_AB;
MSE = SSE/DFE;

F_A = MS_A/MSE;
F_B = MS_B/MSE;
F_AB = MS_AB/MSE;

p_A = 1-fcdf(F_A,DF_A,DFE);
p_B = 1-fcdf(F_B,DF_B,DFE);
p_AB = 1-fcdf(F_AB,DF_AB,DFE);

an.table{1} = sprintf('%12s %8s %8s %8s %8s %8s','Source','SS','DF','MS','F','p <');
an.table{2} = sprintf('%12s %8.3f %8i %8.3f %8.3f %8.4g','Factor A',SS_A,a-1,MS_A,F_A,p_A);
an.table{3} = sprintf('%12s %8.3f %8i %8.3f %8.3f %8.4g','Factor B',SS_B,b-1,MS_B,F_B,p_B);
an.table{4} = sprintf('%12s %8.3f %8i %8.3f %8.3f %8.4g','Interact.',SS_AB,(a-1)*(b-1),MS_AB,F_AB,p_AB);
an.table{5} = sprintf('%12s %8.3f %8i %8.3f','Random',SSE,N-a*b,MSE);
an.table{6} = sprintf('%12s %8.3f %8i','Total (cor.)',SS,N-1);

fprintf('%s\n',an.table{:});

an.SS_A = SS_A;
an.SS_B = SS_B;
an.SS_AB = SS_AB;
an.SSE = SSE;

an.MS_A = MS_A;
an.MS_B = MS_B;
an.MS_AB = MS_AB;
an.MSE = MSE;

an.DF_A = DF_A;
an.DF_B = DF_B;
an.DF_AB = DF_AB;
an.DFE = DFE;

an.F_A = F_A;
an.F_B = F_B;
an.F_AB = F_AB;

an.p_A = p_A;
an.p_B = p_B;
an.p_AB = p_AB;

an.N = N;
an.DF = N-1;

an.data.xx =xx;
an.data.nnn = nnn;
an.data.avg = avg;
an.data.avgi = avgi;
an.data.avgj = avgj;

