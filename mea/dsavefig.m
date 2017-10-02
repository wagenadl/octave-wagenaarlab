function dsavefig(tps,fn)
% DSAVEFIG saves the current figure as an eps with the same name as the 
% calling function. If there is no current function, the date is used
% as a filename: YYMMDD-HHMMSS.ext
% DSAVEFIG('typ typ ...') saves other types, depending on tps:
%   'eps' saves a '.eps'
%   'fig' saves a '.fig'
%   'png' saves a '.png'

if nargin<2
  [st,x] = dbstack;
  if length(st)>=2
    fn = st(2).name;
  else
    clk = clock;
    clk=floor(clk);
    fn = sprintf('%02i%02i%02i-%02i%02i%02i',mod(clk(1),100),clk(2),clk(3),clk(4),clk(5),clk(6));
  end
end



if ~isempty(strmatch('code/',fn))
  fn = [ 'figs/' fn(6:end) ];
end
L=length(fn)
if strcmp(fn(L-1:L),'.m')
  fn = fn(1:L-2);
end

if nargin<1
  tps='eps';
end

tps = strtoks(tps); T=length(tps);

for t=1:T
  if strcmp(tps{t},'fig')
    saveas(gcf,[fn '.fig']);
  elseif strcmp(tps{t},'eps') 
    print('-depsc2',[fn '.eps']);
  elseif strcmp(tps{t},'png')
    print('-dpng','-r200',[fn '.png']);
  else
    error(['Unknown filetype: ' tps{t}]);
  end
  fprintf(1,'Saved ''%s.%s''\n',fn,tps{t});
end
