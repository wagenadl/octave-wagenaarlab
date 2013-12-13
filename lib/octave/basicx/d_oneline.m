function str = d_oneline(v, maxlen, forcebracket)
% D_ONELINE: one line summary of a variable

if nargin<2
  maxlen = 60;
end
if nargin<3
  forcebracket = 0;
end

str = [];
ti = typeinfo(v);
S = size(v);
L = length(v);
  
if isstruct(v)
  str = '';
  if prod(S)~=1
    str = [str d_size(v) ' '];
  end  
  str = [ str 'struct' ];
  fldn = fieldnames(v);
  ichr = ':';
  for n=1:length(fldn)
    str = [ str ichr ' ' fldn{n} ];
    ichr = ',';
  end
elseif iscell(v)
  if prod(S)==L
    % vector
    str = '{';
    sep = '';
    for n=1:length(v)
      str = [ str sep d_oneline(v{n}, maxlen/2, 1) ];
      %      fprintf(2, "d_oneline: str=%s maxlen=%i\n", str, maxlen);
      if length(str)>maxlen
	break;
      end
      if S(1)==1
	% horizontal cell vector
	sep = '  ';
      else
	% vertical cell vector
	sep = '; ';
      end
    end
    str = [ str '}' ];
  end
elseif ischar(v) && prod(S)==L
  str = ["'" v "'"];
elseif ismatrix(v)
  if isempty(v)
    str = '[]';
  elseif isscalar(v)
    str = sprintf('%g', v);
  elseif prod(S)==L
    % vector
    sep = '';
    str = '[';
    for n=1:length(v)
      str = [ str sep sprintf('%g', v(n)) ];
      if length(str)>maxlen
	break;
      end
      if S(1)==1
	sep = '  ';
      else
	sep = '; ';
      end
    end
    str = [ str ']' ];
  end
elseif strcmp(ti, 'function handle')
  str = disp(v);
  while str(1)<=' '
    str = str(2:end);
  end
  while str(end)<=' '
    str = str(1:end-1);
  end
end

if length(str)>maxlen || ~ischar(str)
  str = d_typeinfo(v);
end

  
if forcebracket && ischar(str) 
  if str(1)=='[' || str(1)=='{'
    ;
  else
    str = [ '[' str ']' ];
  end
end
