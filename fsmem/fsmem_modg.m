function y = fsmem_modg(X,K,varargin)
% FSMEM_MOSG - Mixture of spherical Gaussians clustering using FSMEM
%   FSMEM_MOSG is as FSMEM_MOG but assumes Gaussians have diagonal
%   covariance matrices.
%   In output, SIG is a DxK matrix.

kv = getopt('epsi=.01 lambda=.01 maxiter=100 maxcands=5 plot=0', varargin);

epsi = kv.epsi;
lambda = kv.lambda;
max_iter = kv.maxiter;
max_cands = kv.maxcands;

% Some constants:
split_init_epsi = 1;

par = modg_init(X,K);
likelies = zeros(0,1);
iters = zeros(0,1);

par = modg_fullem(X,par,epsi,lambda);
iters = cat(1,iters, par.iters);
likelies = cat(1,likelies, par.likely);

next = 1;
fail = .5;

for iter=1:max_iter;
  
  merits = modg_merits(X,par);
  
  if (next > 0)
    % try to merge
    merge_cands = size(merits.Jmerge,1);
    if (merge_cands > max_cands)
      merge_cands = max_cands;
    end
    para.likely=-1e9;
    for c=1:merge_cands
      m1 = merits.Jmerge(c,2);
      m2 = merits.Jmerge(c,3);
      
      para = modg_mergeinit(par, m1, m2);
      para = modg_truncate(para, m2);
      
      para = modg_partialem(X,para,epsi,lambda,[m1]);
      iters = cat(1,iters, para.iters);
      
      para = modg_fullem(X,para,epsi,lambda);
      iters = cat(1,iters, para.iters);
      
      if (para.likely > par.likely)
	break; % out of candidate test loop
      end
    end % for merge candidates
    if (para.likely > par.likely)
      par = para;
      likelies = cat(1,likelies, par.likely);
      fail = .5;
    else
      fail = fail + 1;
      next = -1;
    end
  else
    % try to split
    split_cands = size(merits.Jsplit,1);
    if (split_cands > max_cands)
      split_cands = max_cands;
    end
    for c=1:split_cands
      s = merits.Jsplit(c,2);
      para = modg_extend(par);
      s2 = length(para.p);
      para = modg_splitinit(para, s, s2, split_init_epsi);
      
      para = modg_partialem(X,para,epsi,lambda,[s,s2]);
      iters = cat(1,iters, para.iters);
      
      para = modg_fullem(X,para,epsi,lambda);
      iters = cat(1,iters, para.iters);
      
      if (para.likely > par.likely)
	break; % out of candidate test loop
      end
    end % for split candidates
    if (para.likely > par.likely)
      par = para;
      likelies = cat(1,likelies, par.likely);
      fail = .5;
    else
      fail = fail+1;
      next = 1;
    end
  end
      
  if (fail > 2)
    break; % out of main loop: split nor merge produced better results
  end
end

if kv.plot
  fprintf(1,'Final result:\n');
  plot_modg(par,X);
end
  
y=par;
[D K] = size(y.mu);
y.sig=zeros(D,K);
for k=1:K
  y.sig(:,k) = par.sig{k}(:);
end
y.likelies = likelies;
y.iters = iters;
