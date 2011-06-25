function y = structcat(dim, y, x)
% STRUCTCAT  Concatenates all vector fields from one structure to another.
%   y = structcat(dim, y, x) cats fields of X onto fields of Y in the DIM
%   dimension. Fields that don't match in dimensions are not affected.

clever = version('-release') >= 14;

fns = fieldnames(y); F=length(fns);
for f=1:F
  try
    if clever
      fy = y.(fns{f});
      fx = x.(fns{f});
      fy = cat(dim,fy,fx);
      y.(fns{f}) = fy;
    else
      fy = getfield(y,fns{f});
      fx = getfield(x,fns{f});
      fy = cat(dim,fy,fx);
      y = setfield(y,fns{f},fy);
    end
  catch
    lasterr(''); % Otherwise, runmatlab(1) will not be happy.
  end
end
