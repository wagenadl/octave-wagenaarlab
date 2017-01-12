function x = gmi_cleanup(x)
% Removes stray non-empty ids from act

% Note that we cannot use "hasidx", because it only says whether the idx
% was manually assigned.
delcan = find(x.deletedcan);
for k=delcan(:)'
  idx = find(x.act.idx==k);
  for i=idx(:)'
    x.act.id{i} = '';
  end
end

