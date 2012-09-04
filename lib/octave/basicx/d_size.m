function str = d_size(v, mx)
% D_SIZE - Reports the size of an object

if nargin<2
  mx = 6;
end

S = size(v);
L = length(S);
str = '';

if L>mx
  str = sprintf('%i-D');
else
  for k=1:L
    if k>1
      str = [ str 'x' ];
    end
    str = [ str sprintf('%i', S(k)) ];
  end
end
