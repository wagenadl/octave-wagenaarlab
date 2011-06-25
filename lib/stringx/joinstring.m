function y = joinstring(x,s)
% JOINSTRING  Glue strings together
%    JOINSTRING(x,s) glues the strings in the cell array X together by
%    injecting S between every pair of elements.

if isempty(x)
  y='';
  return
end
y=[];
for n=1:length(x)-1
  y=[y x{n} s];
end
y=[y x{end}];
