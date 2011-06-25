function str = replace(str,orig,repl)
% str = REPLACE(str,orig,repl) replaces all instances in STR of ORIG 
% by REPL.

L0 = length(orig);
L1 = length(repl);
idx = strfind(str,orig);
K=length(idx);
for k=1:K
  str = [str(1:idx(k)-1), repl, str(idx(k)+L0:end)];
  idx(k+1:end) = idx(k+1:end) + L1-L0;
end

  