function mkcore0(ifn,ofn,tol)
% MKCORE0(ifn,ofn) converts a .reltime and a .idstim file to a .mat file.
% IFN must be the (full) name of the .reltime file, the .idstim file is
% automatically found in the same location.
% Output structures are:
%
% spk.tms - times of spikes (s)
%     chs - channel numbers (hw)
%     hei - height (digital)
%     wid - width (digital)
%     lat - latency (ms)
%     tri - trial number (index into tri structure)
%     thr - threshold (digital), iff there is a fifth column in .reltime.
%
% tri.tms - times of trials (s)
%     trg - autoid0 identifiers for trials
%     raw - raw contexts avgs. % NEW as of 8/10/04
%
% Spikes that do not belong to any trial according to .reltime are assigned
% trial number N+1, where N is the number of real trials in the expt.
% tri.tms and .trg are set to 0 for this "non-trial", spk.lat to NaN.
%
% MKCORE(ifn,ofn,tol) specifies tolerence for autoid0. Default is 50.

if nargin<3
  tol=50;
end

bi=strfind(ifn,'.reltime');
bfn = ifn(1:bi);

rlt = load(ifn);
trg = load([bfn 'idstim']);

[N Q] = size(trg);

if length(tol)<Q-1
  tol=repmat(tol(:),Q,1);
end

%stm = autoid(trg(:,2),10,[],1e-4*length(trg));
aux=zeros(N,Q-1);
for q=1:Q-1
  aux(:,q) = autoid0(trg(:,1+q),tol(q));%,[],min([15 1e-2*length(trg)]));
end

if isempty(rlt)
  rlt=zeros(0,6);
end
spk.tms = rlt(:,1);
spk.chs = rlt(:,2);
spk.hei = rlt(:,3);
spk.lat = rlt(:,5);
spk.tri = rlt(:,6);
if size(rlt,2)>6
  spk.thr = rlt(:,size(rlt,2));
end

if isempty(trg)
  tri.tms = 0;
  tri.trg = zeros(1,10);
  tri.raw = zeros(1,10);
  tri.stm = -1;
  spk.lat(spk.tri==0)=nan;
  spk.tri(spk.tri==0)=1;
else
  tri.tms = trg(:,1);
  tri.trg = aux;
  tri.raw = trg(:,2:end);
  if size(tri.raw,2)>=2
    tri.stm = raw2stm(tri.raw);
  else
    tri.stm = -1+zeros(size(tri.tms));
  end

  N = length(tri.tms);
  tri.tms(N+1) = 0; % No time for non-trial trial
  tri.trg(N+1,:) = 0; % Nor any IDs
  tri.raw(N+1,:) = 0; % Nor raw data
  tri.stm(N+1,:) = -1; % Nor stim ID
  
  spk.lat(spk.tri==0) = nan; % No latency for non-trial spikes
  spk.tri(spk.tri==0) = N+1; % Mark non-trial spikes as such
end

save(ofn, 'spk','tri');
