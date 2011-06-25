function y = trimstruct(y,idx);
% TRIMSTRUCT - Trim all vector members of a structure.
% y = TRIMSTRUCT(y,idx) reduces all vector members of Y to only include
% positions at IDX. IDX must be a logical array, not the output of FIND.
% This is only useful if all vector members have the same length, which
% must be matched by the length of IDX.

fn = fieldnames(y); F=length(fn);
[A B]=size(idx);
for f=1:F
  x = getfield(y,fn{f});
  if A>1
    if size(x,1)==A
      x=x(idx,:);
    end
  elseif B>1
    if size(x,2)==B
      x=x(:,idx);
    end
  elseif A*B==1
    % idx is scalar
    if ~idx
      x=[];
    end
  else
    % idx is empty. this is odd.
  end
  y = setfield(y,fn{f},x);
end


    