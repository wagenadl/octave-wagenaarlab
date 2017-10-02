function spks=loadcleanone(filename,cr)
% spks=LOADCLEANONE(filename,cr) is as loadspks, except that the results
% are filtered through cleanctxt.
% See also loadmanyburstscleanone.

spks=loadspks(filename);
icr=find(spks.channel==cr12hw(cr));
[ctxt, idx]=cleanctxt(spks.context(:,icr));
idx=icr(idx);
spks.time=spks.time(idx);
spks.channel=spks.channel(idx);
spks.height=spks.height(idx);
spks.width=spks.width(idx);
spks.context=ctxt;

