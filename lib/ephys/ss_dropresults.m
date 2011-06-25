function spk = ss_dropresults(spk)
% SS_DROPRESULTS - Remove spike sorting results from a SPIKES structure
%   spk = SS_DROPRESULTS(spk) drops all spike sorting results from SPK
%   so that spike sorting can be started afresh.

flds = strtoks('overcluster hierarchy outliers tictoc');
for f=1:length(flds)
  if isfield(spk, flds{f})
    spk = rmfield(spk, flds{f});
  end
end
