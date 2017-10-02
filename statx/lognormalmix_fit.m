function [tmstmsp,ok]=lognormalmix_fit(xx,tmstmsp0,nofail)
% tmstmsp = LOGNORMALMIX_FIT(xx,tmstmsp0) fits a pdf to the 
% observations XX using Maximum Likelihood (with FMINSEARCH). 
% The pdf is a mixture of two lognormals.
% The function may fail to converge. Use LOGNORMALMIX_FIT(xx,tmstmsp0,1)
% to force infinite reruns

if nargin<2 | isempty(tmstmsp0)
  tmstmsp0=[0 1 1   1 1 1   .5];
end
if nargin<3
  nofail=0;
end
if nofail>1
  its=nofail;
elseif nofail==1
  its=inf;
else
  its=3e3;
end

tmstmsp=zeros(1,7)+nan;
er=0;
while er<=0
  opts = optimset('MaxFunEvals',its,'maxiter',its);
  %%  tmstmsp(7) = lnm_maptoinf(tmstmsp(7));
  [tmstmsp,fv,er] = fminsearchbnd(@(tmstmsp) -lnm_ml(xx,tmstmsp), ...
      tmstmsp0, ...
      [-inf 1e-10 1e-10  -inf 1e-10 1e-10  0], ...
      [inf inf inf inf inf inf  1], ...
      opts);
  %%  tmstmsp(7) = lnm_mapfrominf(tmstmsp(7));
  if er<=0
    if (tmstmsp(7)<.01 | tmstmsp(7)>.99) & nofail>0
      fprintf(1,'Failure to converge - trying with one lognormal...\n');
      if tmstmsp(7)<.5
	tmstmsp=tmstmsp([4 5 6 1 2 3 7]);
      end
      [tmstmsp(1:3),fv,er]=fminsearchbnd(@(tms) -ln1_ml(xx,tms),...
	  tmstmsp(1:3), [-inf 1e-10 1e-10], [inf inf inf], ...
	  opts);
      tmstmsp(7)=1;
    end
    if er<=0
      its=its*2;
    end
  end
  if er<=0
    if its<nofail
      fprintf(1,'Failure to converge - setting maxiter=%i...\n',its);
    else
      fprintf(1,'Failure to converge - giving up\n');
      break;
    end
  end
end
if nargout>1
  ok=er>0;
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ml = lnm_ml(xx,tmstmsp)
p1 = lognormal_pdf(xx,tmstmsp(1),tmstmsp(2),tmstmsp(3));
p2 = lognormal_pdf(xx,tmstmsp(4),tmstmsp(5),tmstmsp(6));
frac = tmstmsp(7);
%% frac = lnm_mapfrominf(tmstmsp(7));
p = frac*p1 + (1-frac)*p2;
ml = sum(log(p+1e-10));


function ml = ln1_ml(xx,tmstmsp)
p = lognormal_pdf(xx,tmstmsp(1),tmstmsp(2),tmstmsp(3));
ml = sum(log(p+1e-10));


function p = lnm_mapfrominf(x)
p = .5+.5*tanh(x);

function x = lnm_maptoinf(p)
x = atanh((p-.5)*2);
