function printall(ofnbase,opts)
% PRINTALL - Print all open figures to files
%    PRINTTO(ofnbase) prints the currently open figures to OFNBASE.
%    If OFNBASE contains the phrase '%i', that gets replaced by the 
%    figure number. Otherwise, the figure number gets interpolated between
%    the base and extension of OFNBASE.
%    PRINTALL(ofnbase,opts) specifies further print options.

if nargin<2
  opts='';
end

if isempty(strfind(ofnbase,'%i'))
  [d,b,e] = splitname(ofnbase);
  ofnbase = [ d filesep b '-%i.' e];
end

ff = sort(findobj(0,'type','figure'));
if isempty(ff)
  f0 = [];
else
  f0 = gcf;
end
K = length(ff);
for k=1:K
  f=ff(k);
  figure(f);
  drawnow
  ofn = sprintf(ofnbase,f);
  fprintf(1,'Printing figure %i (%i/%i) to %s...\n',f,k,K,ofn);
  printto(ofn,opts);
end
if ~isempty(f0)
  figure(f0);
end
