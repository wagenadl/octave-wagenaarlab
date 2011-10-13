function ok = make_eval(str, notreal)
if notreal
  fprintf(1,'  Would run %s\n', str);
  ok = 1;
  return
end

fprintf(1,'  Running %s\n',str);
%try 
  eval(str);
  ok = 1;
%catch xer
%  disp(lasterr)
%  if exist('xer')
%    disp(xer.stack)
%  end
%  fprintf(1,'\nMake failed\n');
%  ok = 0;
%end
