function [m,s]=mmss(sec)
% str = MMSS(sec) returns a string "MM:SS"
% [m,s] = MMSS(sec) returns numbers
% This can also be used for HH:MM, of course.

m = div(sec,60); s = floor(mod(sec,60));

if nargout<=1
  [A,B]=size(s);
  if A*B>1
    mm=m;
    m=cell(A,B);
    for a=1:A
      for b=1:B
	m{a,b} = sprintf('%i:%02i',mm(a,b),s(a,b));
      end
    end
  else
    m = sprintf('%i:%02i',m,s);
  end
  clear s
end
