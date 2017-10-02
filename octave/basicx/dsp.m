function dsp(v)
% DSP - Display the value of a variable compactly
%   DSP(v) displays the value of the variable V compactly. DSP does not
%   recurse into structures.

fprintf(1,'%s ', typeinfo(v));
s=size(v);
prtsize(s);
if isstruct(v)
  fprintf(1,' with fields:\n');
  ff = fieldnames(v);
  for k=1:length(ff);
    f = getfield(v, ff{k});
    s = size(f);
    fprintf(1,'  %s: %s ', ff{k}, typeinfo(f));
    prtsize(s);
    fprintf(1,'');
    if ischar(f)
      if length(f)<50
	fprintf(1,': ''%s''\n', f);
      else
	fprintf(1,': ''%s...''\n', f(1:50));
      end
    elseif ismatrix(f)
      if s(1)==1
	fprintf(1,':\n');
	dspmat(f, 3, 5);
      elseif prod(s(2:end))==1
	fprintf(1,':\n');
	dspmat(f(:)', 1, 5);
      else
	fprintf(1,'\n');
      end
    else
      fprintf(1,'\n');
    end
  end
elseif ismatrix(v)
  fprintf(1,':\n');
  dspmat(v, 8, 8);
end
fprintf(1,'\n');

function dspmat(v, mr, mc)
s=size(v);
for n=1:min(s(1), mr)
  fprintf(1,'  ');
  for m=1:min(s(2), mc)
    fprintf(1,'%8.4g ', v(n,m));
  end
  if s(2)>mc
    fprintf(1,'...');
  end
  fprintf(1,'\n');
end
if s(1)>mr
  fprintf(1,'  ...\n');
end
    
function prtsize(s)
if prod(s)~=1
  fprintf(1,'(%i',s(1));
  for k=2:length(s)
    fprintf(1,'x%i',s(k));
  end
  fprintf(1,')');
end
