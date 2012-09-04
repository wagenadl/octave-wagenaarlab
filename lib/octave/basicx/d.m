function str = d(v, ind)
% D - Display the value of a variable in a compact form.
%   D(v) displays the value of the variable V.
%   It will not print more than what will comfortably fit on a 80x24 
%   terminal.

if nargin<2
  ind = 1;
end

fmt = sprintf('%%%is', ind*2);
inds = sprintf(fmt, '');

str = '';

if ischar(v)
  x=v;
  try
  v = evalin('caller', v);
  str = [ inds x " = \n" ];
  inds = [ inds '  '];
  ind = ind + 1;
  catch
  fprintf(1,'foobar\n');
  end
end

ti=typeinfo(v);
S=size(v);
L=length(v);

if isstruct(v)
  if prod(S)==1
    str = [ str d_struct(v, ind+1)];
  else
    str = [ str inds d_size(v) " struct array with fields:\n" ];
    str = [ str d_structnames(v, ind+1)];
  end
elseif iscell(v)
  if isempty(v)
    str = [ str inds "{empty cell}\n"];
  elseif length(S)>2
    % High dimensional
    str = [ str d_highdimcell(v, ind) ];
  else
    str = [ str d_cell(v, ind) ];
  end
elseif ismatrix(v)
  if isempty(v)
    str = [ str inds d_typeinfo(v) "\n" ];
  elseif length(S)>2
    % High dimensional
    str = [ str d_highdimmatrix(v, ind) ];
  else
    str = [ str d_matrix(v, ind) ];
  end
  
%elseif ischar(v)    
else
  str = [ str inds d_typeinfo(v) "\n" ];
end

if nargout==0
  fprintf(1, '%s', str);
  clear str
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function str = d_struct(v, ind)
str = '';
fldn = fieldnames(v);
N=length(fldn);
L=6;
for n=1:N
  if length(fldn{n})>L
    L=length(fldn{n});
  end
end
fmt = sprintf('%%%is', L+2*ind);
for n=1:length(fldn)
  str = [ str sprintf(fmt, fldn{n}) ': ' d_oneline(v.(fldn{n})) "\n" ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function str = d_structnames(v, ind)
str = '';
fldn = fieldnames(v);
fmt = sprintf('%%%is', 2*ind);
inds = sprintf(fmt, '');
for n=1:length(fldn)
  str = [ str inds fldn{n} "\n"  ];
end

