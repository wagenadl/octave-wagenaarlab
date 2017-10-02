function dps = make_outdated(tgt, deps, mtch)
% MAKE_OUTDATED - Determine list of dependencies newer than target
%    dps = MAKE_OUTDATED(tgt, deps, mtch) returns those dependencies from DEPS
%    relative to which TGT is outdated. In any of DEPS, the wildcard '%' is
%    replaced by MTCH.
%    If TGT doesn't exist, it is outdated relative to all dependencies.
%    A target is also outdated relative to nonexistent dependencies.

if ~startswith(tgt,'/')
  tgt = [ './' tgt ];
end
if exist(tgt, 'file')
  % We need to do some work
  s = stat(tgt);
  t0_tgt = s.mtime;
  
  dps = {};
  for d=1:length(deps)
    dep = strrep(deps{d}, '%', mtch);
    if startswith(dep,'/')
      dp1 = dep;
    else
      dp1 = [ './' dep ];
    end
      
    if exist(dp1, 'file')
      s = stat(dep);
      t0_dep = s.mtime;
      if t0_dep>t0_tgt
	dps{end+1} = dep;
      end
    else
      % Dependency doesn't exist.
      dps{end+1} = dep;
    end
  end
else
  % Target doesn't exist. Outdated to all.
  dps = deps;
  for d=1:length(deps)
    dps{d} = strrep(deps{d}, '%', mtch);
  end
end
