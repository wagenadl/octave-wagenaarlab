function spk = joinspikes(spk, s2)
% JOINSPIKES - Join together the results of two spike detection results
%   spk = JOINSPIKES(s1, s2) joins the results of two calls to TEMPLATESPIKE
%   or similar


fns = fieldnames(spk);
F = length(fns);
for f=1:F
  fn = fns{f};
  spk.(fn) = [spk.(fn); s2.(fn)];
end

[dd, ord] = sort(spk.idx);

for f=1:F
  fn = fns{f};
  spk.(fn) = spk.(fn)(ord);
end

