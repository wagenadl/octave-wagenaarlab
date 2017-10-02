function y = fsmem_mog(X,K,varargin)
% FSMEM_MOG - Mixture of Gaussians clustering using FSMEM
%   y = FSMEM_MOG(xx, K) performs free split/merge EM: DWs modification of
%   Ueda et al split/merge EM algorithm for mixture of gaussians.
%   Input: xx: DxN data 
%          K: initial nr of clusters
%   Additional parameters may be given as (key, value) pairs:
%      epsi (.01): relative change of log likelihood used for termination
%      lambda (.01): fudge parameter to prevent zero-variance attractor
%      maxiter (100): max. # of iterations
%      maxcands (5): max. # of split/merge candidates per iteration
%      plot (0): flag to enable plotting of results.
%   
%   Output: structure with members
%     p:   1xK vector of mixing coefficients
%     mu:  DxK matrix of means
%     sig: DxDxK matrix of variances
%     likelies: successive local optima of log likelihood.
%     iters: succesive iteration counts of em runs: even numbers
%            refer to partial em runs. Discarded runs are included.

kv = getopt('epsi=.01 lambda=.01 maxiter=100 maxcands=5 plot=0', varargin);

epsi = kv.epsi;
lambda = kv.lambda;
max_iter = kv.maxiter;
max_cands = kv.maxcands;

% Some constants:
split_init_epsi = 1;

par = mog_init(X,K);
likelies = zeros(0,1);
iters = zeros(0,1);

par = mog_fullem(X,par,epsi,lambda);
iters = cat(1,iters, par.iters);
likelies = cat(1,likelies, par.likely);

next = 1;
fail = .5;

for iter=1:max_iter;
  
  merits = mog_merits(X,par);
  
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
      
      para = mog_mergeinit(par, m1, m2);
      para = mog_truncate(para, m2);
      
      para = mog_partialem(X,para,epsi,lambda,[m1]);
      iters = cat(1,iters, para.iters);
      
      para = mog_fullem(X,para,epsi,lambda);
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
      para = mog_extend(par);
      s2 = length(para.p);
      para = mog_splitinit(para, s, s2, split_init_epsi);
      
      para = mog_partialem(X,para,epsi,lambda,[s,s2]);
      iters = cat(1,iters, para.iters);
      
      para = mog_fullem(X,para,epsi,lambda);
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
  plot_mog(par,X);
  subplot(3,3,2); title(sprintf('Final result'))
end

y=par;
[D K] = size(y.mu);
y.sig=zeros(D,D,K);
for k=1:K
  y.sig(:,:,k) = par.sig{k};
end
y.likelies = likelies;
y.iters = iters;
