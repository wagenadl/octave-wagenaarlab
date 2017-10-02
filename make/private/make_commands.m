function cmds = make_commands(cmds, tgt, deps, mtch)
% MAKE_COMMANDS - Build commands for make
%    cmds = MAKE_COMMANDS(cmds, tgt, deps, mtch) instantiates the commands
%    in CMDS by replacing '$@', '$<', '$^', and '$>'.

C = length(cmds);
for c=1:C
  cmd = cmds{c};
  cont = 1;
  while cont;
    cont = 0;

    idx = strfind(cmd, '$@');
    if ~isempty(idx)
      idx=idx(1);
      cmd = [ cmd(1:idx-1) '''' tgt '''' cmd(idx+2:end) ];
      cont = 1;
    end
    
    idx = strfind(cmd, '$%');
    if ~isempty(idx)
      idx=idx(1);
      cmd = [ cmd(1:idx-1) '''' mtch '''' cmd(idx+2:end) ];
      cont = 1;
    end
    
    idx = strfind(cmd, '$<');
    if ~isempty(idx)
      idx=idx(1);
      str = strrep(deps{1}, '%', mtch);
      cmd = [ cmd(1:idx-1) '''' str '''' cmd(idx+2:end) ];
      cont = 1;
    end
    idx = strfind(cmd, '$^');
    if ~isempty(idx)
      idx=idx(1);
      str = '';
      for d=1:length(deps);
	str = [ str '''' strrep(deps{1}, '%', mtch) ''', ' ];
      end
      str = str(1:end-2);
      cmd = [ cmd(1:idx-1) str cmd(idx+2:end) ];
      cont = 1;
    end
    idx = strfind(cmd, '$>');
    if ~isempty(idx)
      idx=idx(1);
      str = '';
      for d=2:length(deps)
	str = [ str '''' strrep(deps{d}, '%', mtch) ''', ' ];
      end
      str = str(1:end-2);
      cmd = [ cmd(1:idx-1) str cmd(idx+2:end) ];
      cont = 1;
    end
  end
    
  cmds{c} = cmd;
end
