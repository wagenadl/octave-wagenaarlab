function bursts=loadmanyburstscleanone(basefilename,cr)
% bursts=LOADMANYBURSTSCLEANONE(basefilename,cr) is as loadmanyburstclean,
% except that only one channel is processed, and contexts *are* returned.

bursts=cell(1,0);
for i=1:100000
  fn=sprintf(basefilename,i);
  if exist(fn) ~= 2
    break;
  end
  fprintf(2,'Processing file %i\n',i);
  spks=loadspks(fn);
  icr=find(spks.channel==cr12hw(cr));
  [ctxt, idx]=cleanctxt(spks.context(:,icr));
  idx=icr(idx);
  bursts{i}.time=spks.time(idx);
  bursts{i}.channel=spks.channel(idx);
  bursts{i}.height=spks.height(idx);
  bursts{i}.width=spks.width(idx);
  bursts{i}.context=ctxt;
end
