function spks = megaload_spikes(fns,scl)
if nargin<2
  scl=3;
end
K=length(fns);
spks=cell(1,K);
for k=1:K
  fprintf(2,'Loading %i/%i: %s\n',k,K,fns{k});
  spks{k} = loadspike_noc(fns{k},scl);
end
