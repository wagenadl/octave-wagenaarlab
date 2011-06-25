function [i_on,i_off] = simpleburst(t_spk,dt_thr,dt_thr2)
% [i_on,i_off] = SIMPLEBURST(t_spk,dt_thr,dt_thr2)
% Returns the indices of the first and last spikes in all bursts.
% This is based on Schmitt triggering of inter-spike intervals.
% Primitive, but reasonably effective.
% (DT_THR2, if supplied, should be larger than DT_THR.)

if nargin<3
  dt_thr2=dt_thr*1.001;
end

dt_spk = [inf diff(t_spk(:)')];

[i_on,i_off] = schmitt(1./dt_spk,1./dt_thr,1./dt_thr2);
i_on = i_on-1;
i_off= i_off-1;
%i_on   = find(dt_spk(2:end)<dt_thr & dt_spk(1:end-1)>=dt_thr);
%i_off  = find(dt_spk(2:end)>dt_thr & dt_spk(1:end-1)<=dt_thr);  
