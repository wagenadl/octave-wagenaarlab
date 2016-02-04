function str = pf_joinstr(cel)
% PF_JOINSTR - Joins cell contents into a single structure for after PARFARM
%   str = PF_JOINSTR(cel) takes a cell vector containing structures with
%   identical field names, and returns a single structure with the same fields
%   that are concatenations of the fields in each cell.
%   More specifically, for fields that are scalars in every non-empty cell,
%   the result is an Nx1 vector. All other fields result in Nx1 cell vectors
%   within the structure.

N = length(cel);

n0 = [];
for n=1:N
  if ~isempty(cel{n})
    n0 = n;
    break;
  end
end

str = struct();
if isempty(n0)
  return
end

fn = fieldnames(cel{n0});
F = length(fn);

isscl = logical(ones(F,1));
for n=1:N
  if ~isempty(cel{n})
    for f=1:F
      if ~isnvector(cel{n}.(fn{f})) || ~isscalar(cel{n}.(fn{f}))
	isscl(f) = 0;
      end
    end
  end
end

for f=1:F
  if isscl(f)
    str.(fn{f}) = zeros(N,1) + nan;
  else
    str.(fn{f}) = cell(N,1);
  end
end

for n=1:N
  if ~isempty(cel{n})
    for f=1:F
      if isscl(f)
	str.(fn{f})(n) = cel{n}.(fn{f});
      else
	str.(fn{f}){n} = cel{n}.(fn{f});
      end
    end
  end
end
