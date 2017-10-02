function b = Squeeze(a)
% B = SQUEEZE(A) returns an array B with the same elements as
% A but with all the singleton dimensions removed.  A singleton
% is a dimension such that size(A,dim)==1.  The only difference with 
% the "squeeze" builtin, is that row vectors are converted to column
% vectors.
%
% For example, squeeze(rand(1,5)) is 5-by-1.
 
if nargin==0, error('Not enough input arguments.'); end
 
if ndims(a)>2
  b = squeeze(a);
else
  [A B] = size(a);
  if A==1
    b=a';
  else
    b=a;
  end
end
