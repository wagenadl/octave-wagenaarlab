function mkcore(ifn,ofn,tol)

if nargin<3
  tol=30;
end

bi=strfind(ifn,'.reltime');
bfn = ifn(1:bi);

rlt = load(ifn);
trg = load([bfn 'idstim']);

[N Q] = size(trg);

%stm = autoid(trg(:,2),10,[],1e-4*length(trg));
aux=zeros(N,Q-1);
for q=1:Q-1
  aux(:,q) = autoid(trg(:,1+q),tol);%,[],min([15 1e-2*length(trg)]));
end

spk.tms = rlt(:,1);
spk.chs = rlt(:,2);
spk.hei = rlt(:,3);
spk.lat = rlt(:,5);
spk.tri = rlt(:,6);

tri.tms = trg(:,1);
tri.trg = aux;

save(ofn, 'spk','tri');
