function bursts=loadmanyburstsnoc(basefilename)
% bursts=LOADMANYBURSTSNOC(basefilename) is as loadspksnoc, except that
% a cell array of structures is returned, one for each burst that could be
% loaded by replacing %i in BASEFILENAME by a sequence number.

bursts=cell(1,0);
for i=1:100000
  fn=sprintf(basefilename,i);
  if exist(fn) ~= 2
    break;
  end
  bursts{i} = loadspksnoc(fn);
end
