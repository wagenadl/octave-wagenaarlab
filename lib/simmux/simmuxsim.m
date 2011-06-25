function simmuxsim(fn)
% SIMMUXSIM(fn) converts the output of SIMMUX to more usable block-free format
% Output is saved to a file "FN.sim.mat", which contains the foll. variables:
%
% bbb: information about simplex bursts (see SIMPLEXBURST)
% mmm: information about multix bursts (see MULTIXBURST)
% nnn: information about "disjoined" multix bursts (see DISJOINXBURST)
% sss: information about "core" superbursts (see SUPERXBURST)
% ttt: information about "expanded" superbursts (see EXPANDXBURST)
%
% For most purposes, using TTT is preferred over using SSS, and using 
% NNN is preferred over using MMM.

fprintf(2,'Loading simmux - %s.mat\n',fn);
load([fn '.mat']);

fprintf(2,'Collecting simplex bursts - %s\n',fn);
bbb.dt_max = bb{1}.dt_max;
bbb.n_min = bb{1}.n_min;
bbb.n_min_min = bb{1}.n_min_min;
bbb.dt_min = bb{1}.n_min;
bbb.frthr_min = bb{1}.frthr_min;
bbb.frthr_max = bb{1}.frthr_max;

bbb.onset=[];
bbb.offset=[];
bbb.nspikes=[];
bbb.channel=[];
bbb.tmean=[];
bbb.stddur=[];
bbb.good=[];

B=length(bb);
base=zeros(1,B);
bs=0;
for b=1:B
  base(b)=length(bbb.onset);
  bbb.onset=[bbb.onset; bb{b}.onset];
  bbb.offset=[bbb.offset; bb{b}.offset];
  bbb.nspikes=[bbb.nspikes; bb{b}.nspikes];
  bbb.channel=[bbb.channel; bb{b}.channel];
  bbb.tmean=[bbb.tmean; bb{b}.tmean];
  bbb.stddur=[bbb.stddur; bb{b}.stddur];
  bbb.good=[bbb.good; bb{b}.good];
end

fprintf(2,'Collecting disjoined multix bursts - %s\n',fn);
nnn.onset=[];
nnn.offset=[];
nnn.monset=[];
nnn.moffset=[];
nnn.cmap=[];
nnn.gmap=[];
nnn.comap=[];
nnn.cc=[];
nnn.co=[];
nnn.gg=[];
nnn.cspks=[];
nnn.netspks=[];
nnn.totspks=[];
nnn.good=[];
nnn.gonset=[];
nnn.goffset=[];
nnn.qonset=[];
nnn.qoffset=[];
nnn.constit={};
M=length(cc);
if M~=B
  error('Whoa! - block mismatch');
end
for m=1:M
  gd=find(dd{m}.good>0);
  nnn.onset=[nnn.onset; dd{m}.onset(gd)];
  nnn.offset=[nnn.offset; dd{m}.offset(gd)];
  nnn.monset=[nnn.monset; dd{m}.monset(gd)];
  nnn.moffset=[nnn.moffset; dd{m}.moffset(gd)];
  nnn.cmap=[nnn.cmap; dd{m}.cmap(gd,:)];
  nnn.comap=[nnn.comap; dd{m}.comap(gd,:)];
  nnn.gmap=[nnn.gmap; dd{m}.gmap(gd,:)];
  nnn.totspks=[nnn.totspks; (dd{m}.comap(gd,:).*(dd{m}.comap(gd,:)>2))*dd{m}.frbase'];
  nnn.cc=[nnn.cc; dd{m}.cc(gd)];
  nnn.gg=[nnn.gg; dd{m}.gg(gd)];
  nnn.co=[nnn.co; dd{m}.co(gd)];
  nnn.cspks=[nnn.cspks; dd{m}.cspks(gd,:)];
  nnn.netspks=[nnn.netspks; dd{m}.netspks(gd)];
  nnn.good=[nnn.good; dd{m}.good(gd)];
  nnn.gonset=[nnn.gonset; dd{m}.gonset(gd)];
  nnn.goffset=[nnn.goffset; dd{m}.goffset(gd)];
  nnn.qonset=[nnn.qonset; dd{m}.qonset(gd)];
  nnn.qoffset=[nnn.qoffset; dd{m}.qoffset(gd)];
  g0=length(nnn.constit);
  for g=1:length(gd)
    nnn.constit{g+g0,1}=dd{m}.constit{gd(g)}(:)+base(m);
  end
end

fprintf(2,'Finding superbursts - %s\n',fn);
kk=bigxburst(nnn,.25);
sss=superxburst(nnn,kk,10,2);

fprintf(2,'Expanding superbursts - %s\n',fn);
ttt=expandxburst(sss,nnn,kk,1);

fprintf(2,'Saving - %s.sim.mat\n',fn);
save([ fn '.sim.mat'],'bbb','nnn','sss','ttt');
