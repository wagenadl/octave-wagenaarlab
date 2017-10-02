function spikes = ss_subset(spikes, typ, sel, sel2)
% SS_SUBSET - Extract a subset of spikes
%    spikes = SS_SUBSET(spikes, 'cluster', sel) retains only those spikes 
%    with cluster assignments in SEL.
%    spikes = SS_SUBSET(spikes, 'time', t0, t1) retains only those spikes 
%    with times between t0 and t1.
%    spikes = SS_SUBSET(spikes, 'index', i0, i1) retains only those spikes 
%    with indices between i0 and i1.

switch typ
  case 'cluster'
    if isfield(spikes,'hierarchy')
      asg = spikes.hierarchy.assigns;
    else
      asg = spikes.overcluster.assigns;
    end
    
    N=length(asg);
    ok=asg>asg; % false
    S=length(sel);
    for s=1:S
      ok(asg==sel(s)) = 1;
    end
  case 'time'
    ok = spikes.spiketimes>=sel & spikes.spiketimes<sel2;
  case 'index'
    idx = [1:length(spikes.spiketimes)];
    ok = idx>=sel & idx<=sel2;
  otherwise
    error('SS_SUBSET: Invalid selection criterion');
end
spikes.waveforms = spikes.waveforms(ok,:);
spikes.spiketimes = spikes.spiketimes(ok);
if isfield(spikes,'hierarchy')
  spikes.hierarchy.assigns = spikes.hierarchy.assigns(ok);
end
if isfield(spikes,'overcluster')
  spikes.overcluster.assigns = spikes.overcluster.assigns(ok);
end

spikes.selected = find(ok);
