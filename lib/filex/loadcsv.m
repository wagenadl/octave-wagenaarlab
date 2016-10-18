function str = loadcsv(fn)
% LOADCSV - Load CSV into labeled variables
%    STR = LOADCSV(fn) loads the .CSV file FN, which may optionally
%    have column headers.
c0 = csv2cell(fn);
[R C] = size(c0);
couldbechar = logical(zeros(1,C));
for c=1:C
  couldbechar(c) = ischar(c0{1,c}) || isempty(c0{1,c});
end
hdr = cell(1,C);
if all(couldbechar)
  for c=1:C
    if isempty(c0{1,c})
      s = sprintf('X%i', c);
    else
      s = c0{1,c};
    end
    s(s<'0' | (s>'9' & s<'A') | (s>'Z' & s<'a') | s>'z') = '_';
    hdr{c} = s;
  end
  R1 = 2;
else
  for c=1:C
    hdr{c} = sprintf('X%1', c);
  end
  R1 = 1;
end

for c=1:C
  couldbechar = logical(ones(R,1));
  for r=R1:R
    couldbechar(r) = ischar(c0{r,c}) || isempty(c0{r,c});
  end
  if all(couldbechar)
    col = c0(R1:R,c);
  else
    col = zeros(R+1-R1,1) + nan;
    for r=R1:R
      if isnumeric(c0{r,c}) && isscalar(c0{r,c})
	col(r+1-R1) = c0{r,c};
      end
    end
  end
  str.(hdr{c}) = col;
end
