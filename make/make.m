function [ok, flags] = make(tgt, mk, flags)
% MAKE - Simple matlab version of make(1)
%    MAKE builds the first target in m.Makefile.
%    MAKE(target) builds a specific target.
%    MAKE(target, makefile) specifies an alternative makefile.
%    MAKE('-n', ...) just parses the makefile and show what would be done
%
%    Makefile syntax is a much simplified version of GNU Makefiles:
%    Variables can be defined by the syntax:
%      VAR = VALUE
%    for instance:
%      FILELIST = foo.mat bar.mat
%    Target dependencies are written as:
%      TARGET: DEPENDENCIES
%              COMMAND
%    For instance:
%      foo.mat: bar.mat baz.m
%              baz('bar')
%    Generic rules can utilize the % syntax, for instance:
%      %-spk.mat: %-raw.mat
%              extract($^)
%    Note the use of the automatic variable $^, which expands to a comma-
%    separated list of single-quote enclosed dependencies.
%    The automatic variable $< expands to only the first dependency, and,
%    in an extension to GNU syntax, $> expands to all but the first dependency.
%    $@ expands to the name of the target, $% expands to the substitution
%    of '%' in the rule. All of these will be placed in quotes.
%    User-defined variables can be referenced as $VAR, which implies no
%    quotes, or $'VAR which does create quotes and comma separation. 
%    A new addition is $!VAR which expands multiple times much like a typical
%    use of $(foreach). For instance:
%       FOO=123
%       BASE=x y
%       BAR=foo-$!BASE.mat
%       # BAR is now foo-x.mat foo-y.mat
%       foo.mat: combine.m $BAR other.mat
%            combine($@, { $'BAR }, $FOO)
%        # That runs combine('foo.mat', { 'foo-x.mat', 'foo-y.mat' }, 123)
%    Empty lines are ignored. Pound sign (#) introduces comments.
%    Makefiles are parsed in one pass. That means that variables must be
%    defined before they are used.
%    Finally, $. is replaced by nothing and $$ is replaced by '$'.

ok = 1;

if nargin<3
  flags.deep=0;
  flags.notreal=0;
  flags.verbose=0;
  flags.reported={};
end
if nargin<2
  mk = 'm.Makefile';
end
if nargin<1
  tgt = [];
end

if ~isempty(tgt) & tgt(1)=='-'
  flagn = tgt(2:end);
  if nargin>1
    tgt = mk;
  else
    tgt = [];
  end
  if nargin>2
    mk = flags;
  else
    mk = 'm.Makefile';
  end
  flags.deep=0;
  flags.notreal = any(flagn=='n');
  flags.verbose = any(flagn=='v');
  flags.reported = {};
end

if ischar(mk)
  mk = make_readMakefile(mk);
end

if flags.verbose
  if flags.deep==0
    if isempty(mk.var.keys)
      fprintf(1,'(Makefile has no variables.)\n');
    else
      fprintf(1,'Makefile variables are:\n');
      for k=1:length(mk.var.keys)
	fprintf(1,'  %s: %s\n', mk.var.keys{k}, mk.var.values{k});
      end
    end
  end
end

if isempty(mk.rule.targets)
  fprintf(1, 'Nothing to make\n');
  if nargout==0
    clear ok
  end
  return;
end

if isempty(tgt)
  tgt = mk.rule.targets{1};
end

idx = strmatch(tgt, mk.rule.targets, 'exact');
mtch = '';
if isempty(idx)
  % No exactly matching rule for this target
  for n=1:length(mk.rule.targets)
    mtch = make_matches(tgt, mk.rule.targets{n});
    if ~isempty(mtch)
      % Pattern match
      idx = n;
      break;
    end
  end
end

if isempty(idx)
  if exist(tgt,'file')
    if isempty(strmatch(tgt, flags.reported, 'exact'))
      fprintf(1, '%s will be used as-is.\n', tgt);
      flags.reported{end+1} = tgt;
    end
  else
    fprintf('No rule to make %s.\n', tgt);
    ok=0;
    if nargout==0
      clear ok
    end
    return;
  end
else
  dps = mk.rule.deps{idx};
  for k=1:length(dps)
    dep = strrep(dps{k}, '%', mtch);
    if flags.verbose
      fprintf(1, '%s depends on %s.\n', tgt, dep);
    end
    fl = flags;
    fl.deep = 1;
    [okk, fl] = make(dep, mk, fl);
    flags.reported = fl.reported;
    if ~okk
      ok=0;
    end
  end
  if ok==0
    fprintf(1, 'Giving up.\n');
    if nargout==0
      clear ok
    end
    return;
  end

  dps = make_outdated(tgt, mk.rule.deps{idx}, mtch);
  if isempty(dps) & exist(tgt, 'file')
    if flags.verbose
      fprintf(1, '%s is up-to-date.\n', tgt);
    end
  else
    fprintf(1,'Will make %s.\n', tgt);
    % Now, let's make our target
    cmds = make_commands(mk.rule.cmds{idx}, tgt, mk.rule.deps{idx}, mtch);
    for k=1:length(cmds)
      if ~make_eval(cmds{k}, flags.notreal)
	ok = 0;
	if nargout==0
	  clear ok
	end
	return
      end
    end
    fprintf(1,'Done making %s.\n', tgt);
  end
end

if ~flags.deep
  fprintf(1,'Make complete\n');
end

if nargout==0
  clear ok
end
