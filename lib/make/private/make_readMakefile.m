function mk = make_readMakefile(mkf)
% MAKE_READMAKEFILE - Internal function of MAKE to parse Makefiles
fd = fopen(mkf, 'r');
if fd<0
  error(sprintf('Cannot open %s', mkf));
end

mk.var.keys = {};
mk.var.values = {};
mk.rule.targets = {};
mk.rule.deps = {};
mk.rule.cmds = {};

lastidx=[];
while ~feof(fd)
  tline = fgetl(fd);
  if ~ischar(tline)
    break;
  end
  if all(tline<=' ')
    lastidx=[];
    continue;
    % Empty line breaks command sequence
  end
  idx = find(tline=='#');
  if ~isempty(idx)
    tline = tline(1:idx(1)-1);
  end
  if all(tline<=' ')
    continue;
    % ... but comment line does not.
  end
  
  idxeq = find(tline=='=');
  idxco = find(tline==':');
  if tline(1)<=' '
    % Got a command expansion
    if isempty(lastidx)
      error('Last was not a dependency. Unexpected command.');
    else
      cmd = make_varexpand(strip(tline), mk.var);
      for idx = lastidx(:)'
	mk.rule.cmds{lastidx}{end+1} = cmd;
      end
    end
  elseif ~isempty(idxeq) & (isempty(idxco) | idxeq(1)<idxco(1))
    % Got a variable definition
    k = strip(tline(1:idxeq(1)-1));
    v = strip(tline(idxeq(1)+1:end));
    idx = strmatch(k, mk.var.keys, 'exact');
    if isempty(idx)
      idx = length(mk.var.keys)+1;
    end
    mk.var.keys{idx,1} = k;
    mk.var.values{idx,1} = make_varexpand(v, mk.var);
    lastidx = [];
  elseif ~isempty(idxco) & (isempty(idxeq) | idxco(1)<idxeq(1))
    % Got a dependency definition
    tgt = strtoks(make_varexpand(strip(tline(1:idxco(1)-1))));
    dep = strtoks(make_varexpand(strip(tline(idxco(1)+1:end)), mk.var));
    T = length(tgt);
    lastidx = [];
    for t=1:T
      idx = strmatch(tgt{t}, mk.rule.targets, 'exact');
      if isempty(idx)
	idx = length(mk.rule.targets)+1;
      end
      mk.rule.targets{idx} = tgt{t};
      if length(mk.rule.deps)<idx
	mk.rule.deps{idx} = {};
      end
      D = length(dep);
      mk.rule.deps{idx}(end+1:end+D) = dep;
      if length(mk.rule.cmds)<idx
	mk.rule.cmds{idx} = {};
      end
      lastidx(end+1) = idx;
    end
  end
end
fclose(fd);
