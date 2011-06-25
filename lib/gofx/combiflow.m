function combiflow(itempl,ofn,maxfr,info)
% COMBIFLOW - Combine OFLOW results into one matlab file
%    COMBIFLOW(itempl,ofn,maxfr) combines multiple OFLOW/GOF results into
%    one matlab file, inserting 2..MAXFR into ITEMPL to generate input files.
%    The output is stored as a cell array of int16s at 1000x scale.
%    No integration is performed; see OFSEQ for that.

if nargin<4
  info='';
end

dx=cell(maxfr,1);
dy=cell(maxfr,1);
X=nan; Y=nan;

for a=2:maxfr
  [x,y] = readof(sprintf(itempl,a));
  dx{a} = int16(x*1000);
  dy{a} = int16(y*1000);
  if ~isempty(dx{a})
    [Y X]=size(dx{a});
  end
end

save(ofn,'dx','dy','X','Y','info');