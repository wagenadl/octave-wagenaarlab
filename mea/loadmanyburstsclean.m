function bursts=loadmanyburstsclean(basefilename)
% bursts=LOADMANYBURSTSCLEAN(basefilename) is as loadmanyburstsnoc, except
% that the contexts are read as well and used to clean the spikes through
% cleanctxt. The contexts are not returned.

bursts=cell(1,0);
for i=1:100000
  fn=sprintf(basefilename,i);
  if exist(fn) ~= 2
    break;
  end
  fprintf(2,'Processing file %i\n',i);
  spks=loadspks(fn);
  [ctxt, idx]=cleanctxt(spks.context);
  bursts{i}.time=spks.time(idx);
  bursts{i}.channel=spks.channel(idx);
  bursts{i}.height=spks.height(idx);
  bursts{i}.width=spks.width(idx);
end
