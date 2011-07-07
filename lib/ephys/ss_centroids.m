function [cc, s] = ss_centroids(spk)
% SS_CENTROIDS - Calculate centroids for sorted spikes
%    w0 = SS_CENTROIDS(spikes) calculates centroids for a given spike
%    structure. Clusters that have no spikes in them yield NaN centroids.
%    [w0, s] = SS_CENTROIDS(spikes) also returns a structure vector of 
%    per-cluster shape information:
%      First, for each wave form w_k(t) in the cluster, we fit
%        w_k (t) = a_k * w0(t) + b_k + (error term),
%      then we calculate
%        v_k (t) = (a_k)^-1 (w_k(t) - b_k).
%      We also calculate
%        dw_k (t) = w_k (t) - w0(t)
%      and
%        dv_k (t) = v_k (t) - w0(t),
%      and from there:
%        r_wk = rms_t dw_k(t)
%      and
%        r_vk = rms_t dv_k(t)
%      where
%        rms_t f(t) := sqrt(sum_t (f(t)^2))
%      The structure s contains:
%         N: number of spikes in the cluster
%         sw: ssd of dw_k(t) [over k and t indiscriminately]
%         sv: ssd of dv_k(t) [over k and t indiscriminately]
%         sa: ssd of a_k
%         mrw: mean of r_wk
%         srw: ssd of r_wk
%         mrv: mean of r_vk
%         srv: ssd of r_vk
%         ss: sqrt(sw^2 - sv^2), i.e., error due to scaling
%      It also contains the following less useful quantities:
%         ma: mean of a_k, which should be very close to 1 (by 1e-14 or so)
%         mb: mean of b_k, which should be very close to 0 (by 1e-14 or so)
%         sb: ssd of b_k, which should be very close to 0 (by 1e-14 or so)

Q=max(spk.hierarchy.assigns);
[N T]=size(spk.waveforms);
cc = zeros(Q,T) + nan;


if nargout>=2
  s.N = zeros(1,Q);
  
  s.sa  = zeros(1,Q) + nan;
  s.sb	= zeros(1,Q) + nan;
  s.ma	= zeros(1,Q) + nan;
  s.mb	= zeros(1,Q) + nan;

  s.sw	= zeros(1,Q) + nan;
  s.sv	= zeros(1,Q) + nan;
  s.mrw	= zeros(1,Q) + nan;
  s.srw	= zeros(1,Q) + nan;
  s.mrv	= zeros(1,Q) + nan;
  s.srv	= zeros(1,Q) + nan;

  s.ss  = zeros(1,Q) + nan;
end

for q=1:Q
  idx = find(spk.hierarchy.assigns==q);
  K = length(idx);
  if K>0
    wv = spk.waveforms(idx,:);
    cc(q,:) = mean(wv);
    if nargout>=2
      w0 = cc(q,:);

      % Linear fit:
      %   y = ax + b
      % chi2 = sum (ax + b - y)^2
      % dchi2/da = 0 <=> sum 2 (ax + b - y) * x = 0 
      % dchi2/db = 0 <=> sum 2 (ax + b - y) = 0
      % Thus:
      %   a sum x^2 + b sum x - sum xy = 0
      %   a sum x   + b sum 1 - sum y  = 0
      % Write this as
      %   sxx a + sx b = sxy
      %   sx  a + s1 b = sy
      % Multiply by (s1,sx) and subtract:
      %   (sxx s1 - sx sx) a = sxy s1 - sy sx
      % Multiple by (sx,sxx) and subtract
      %   (sx sx - s1 sxx) b = sxy sx - sy sxx
      % Or, more easily, simply set
      %   b = (sy - a sx) / s1.
      
      s1 = repmat(T, [K 1]);
      sx = repmat(sum(w0, 2), [K 1]);
      sy = sum(wv, 2);
      sxy = sum(repmat(w0, [K 1]).*wv, 2);
      sxx = repmat(sum(w0.^2, 2), [K 1]);
      aa = (sxy.*s1 - sy.*sx) ./ (sxx.*s1 - sx.*sx);
      bb = (sy - aa.*sx) ./ s1;
      s.sa(q) = std(aa);
      s.sb(q) = std(bb);
      s.ma(q) = mean(aa);
      s.mb(q) = mean(bb);
      vv = (wv - repmat(bb, [1 T])) ./ repmat(aa, [1 T]);
      s.sv(q) = std(vv(:));
      
      rwk2 = mean((wv - repmat(w0, [K 1])).^2, 2);
      rvk2 = mean((vv - repmat(w0, [K 1])).^2, 2);
      rwk = sqrt(rwk2);
      rvk = sqrt(rvk2);

      s.sw(q) = sqrt(mean(rwk2));
      s.sv(q) = sqrt(mean(rvk2));
      s.mrw(q) = mean(rwk);
      s.srw(q) = std(rwk);
      s.mrv(q) = mean(rvk);
      s.srv(q) = std(rvk);
      
      s.ss(q) = sqrt(s.sw(q)^2 - s.sv(q)^2);
      s.N(1,q) = K;
    end
  end
end
