function dbg(fmt,varargin)
% DBG  Write formatted data to stdout.
%    DBG(fmt,...) is like FPRINTF(1,fmt,...). 

addnl=1;
if length(fmt)>0
  if fmt(end)=='\n'
    addnl=0;
  end
end
dt=datestr(now,13);
dt(9)='.';
fprintf(1,'[%s] ',dt);
fprintf(1,fmt,varargin{:});
if addnl
  fprintf(1,'\n');
end
