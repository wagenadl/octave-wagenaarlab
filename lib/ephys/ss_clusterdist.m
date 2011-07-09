function [d, ds] = ss_clusterdist(wv, cc, s)
% SS_CLUSTERDIST - Distance to clusters
%   d = SS_CLUSTERDIST(wv, cc) returns the distance matrix between the
%   waveforms WV (NxT) and the cluster centroids CC (QxT). Its shape is NxQ.
%   [d, ds] = SS_CLUSTERDIST(wv, cc, s) where S is a cluster shape structure
%   as returned by SS_CENTROIDS returns a set of additional measures:
%     a, b: fit parameters for wv = a cc + b + (error)
%     ta: t-value for a given the distribution of A-values per cluster
%     rw: rms of (wv - cc) (identical to the value of D)
%     rv: rms of ((wv-b)/a - cc)
%     trw: t-value for (wv - cc)
%     trv: t-value for (wv-b)/a - cc
%   Note that TA should be tested with two-tails test, but TRW and TRV with
%   one-tailed tests.

[N T] = size(wv);
[Q T2] = size(cc);
if T2~=T
  error('Centroids and waveforms do not have the same shape');
end

d = zeros(N, Q);
for q=1:Q
  d(:,q) = sqrt(mean((wv - repmat(cc(q,:), [N 1])).^2, 2));
end

if nargin>=3
  if nargout>=2
    
    ds.a   = zeros(N,Q) + nan;
    ds.b   = zeros(N,Q) + nan;
    ds.rw  = zeros(N,Q) + nan;
    ds.rv  = zeros(N,Q) + nan;
    ds.ta  = zeros(N,Q) + nan;
    ds.trw = zeros(N,Q) + nan;
    ds.trv = zeros(N,Q) + nan;
    
    for q=1:Q
      if s.N(q)>0
        w0 = cc(q,:);
        s1 = repmat(T, [N 1]);
        sx = repmat(sum(w0, 2), [N 1]);
        sy = sum(wv, 2);
        sxy = sum(repmat(w0, [N 1]).*wv, 2);
        sxx = repmat(sum(w0.^2, 2), [N 1]);
        aa = (sxy.*s1 - sy.*sx) ./ (sxx.*s1 - sx.*sx);
        bb = (sy - aa.*sx) ./ s1;
        
        ds.a(:,q) = aa;
        ds.b(:,q) = bb;
        ds.ta(:,q) = (aa-1)./s.sa(:,q);
	
        vv = (wv - repmat(bb, [1 T])) ./ repmat(aa, [1 T]);
        dw = wv - repmat(w0, [N 1]);
        dv = vv - repmat(w0, [N 1]);
	ds.rw(:,q) = sqrt(mean(dw.^2, 2));
	ds.rv(:,q) = sqrt(mean(dv.^2, 2));
        ds.trw(:,q) = (ds.rw(:,q) - s.mrw(:,q)) ./ s.srw(:,q);
        ds.trv(:,q) = (ds.rv(:,q) - s.mrv(:,q)) ./ s.srv(:,q);
      end
    end
  
    %ds.pa = erfc(abs(ds.ta)/sqrt(2)); % Two tailed
    %ds.prw = .5*erfc(abs(ds.trw)/sqrt(2)); % One tailed
    %ds.prv = .5*erfc(abs(ds.trv)/sqrt(2)); % One tailed
    ds.pa = exp(-.5*ds.ta.^2);
    ds.prw = exp(-.5*ds.trw.^2);
    ds.prv = exp(-.5*ds.trv.^2);
  end
end


