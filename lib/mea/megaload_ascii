function data = megaload_ascii(fns)
if nargin<2
  scl=3;
end
K=length(fns);
data=cell(1,K);
for k=1:K
  fprintf(2,'Loading %i/%i: %s\n',k,K,fns{k});
  data{k} = load(fns{k},'-ascii');
end
