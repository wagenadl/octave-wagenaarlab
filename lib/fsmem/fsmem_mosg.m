function y = fsmem_mosg(X,K,varargin)
% FSMEM_MOSG - Mixture of spherical Gaussians clustering using FSMEM
%   FSMEM_MOSG is as FSMEM_MOG but assumes Gaussians are spherical, i.e.,
%   covariance matrices are sigma x the unit matrix.
%   In output, SIG is just a 1xK vector.

kv = getopt('epsi=.01 lambda=.01 maxiter=100 maxcands=5 plot=0', varargin);

epsi = kv.epsi;
lambda = kv.lambda;
max_iter = kv.maxiter;
max_cands = kv.maxcands;

% Some constants:
split_init_epsi = 1;

par = mosg_init(X,K);
likelies = zeros(0,1);
iters = zeros(0,1);

par = mosg_fullem(X,par,epsi,lambda);
iters = cat(1,iters, par.iters);
likelies = cat(1,likelies, par.likely);

FIG = 1;

fprintf(1,'First run converged after %i iterations\n',par.iters);
figure(FIG);

next = 1;
fail = .5;

for iter=1:max_iter;
  if kv.plot
    plot_mosg(par,X);
    FIG = 3 - FIG;
    figure(FIG);
    fprintf(1,'mosg_smem: major iteration %i\n', iter);
  end
  
  merits = mosg_merits(X,par);
  
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
      
      para = mosg_mergeinit(par, m1, m2);
      para = mosg_truncate(para, m2);
      
      fprintf(1,'Trying merge candidate %i [%i %i]:\n',c,m1,m2);
      if kv.plot
	para.R = mosg_responsibility(X,para); % For plot only
	plot_mosg(para,X);
      end
      
      para = mosg_partialem(X,para,epsi,lambda,[m1]);
      iters = cat(1,iters, para.iters);
      
      fprintf(1,'Partial EM converged after %i\n',para.iters);
      if kv.plot
	plot_mosg(para,X);
      end
      
      para = mosg_fullem(X,para,epsi,lambda);
      iters = cat(1,iters, para.iters);
      
      fprintf(1,'Full EM converged after %i\n',para.iters);
      if kv.plot
	plot_mosg(para,X);
      end
      
      if (para.likely > par.likely)
	fprintf(1,'Improvement found from merge candidate %i. New K is %i\n',c,length(para.p));
	break; % out of candidate test loop
      end
    end % for merge candidates
    if (para.likely > par.likely)
      par = para;
      likelies = cat(1,likelies, par.likely);
      fprintf(1,'Setting par to para from merge. New K is %i\n',length(par.p));
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
      para = mosg_extend(par);
      s2 = length(para.p);
      para = mosg_splitinit(para, s, s2, split_init_epsi);
      fprintf(1,'Trying split candidate %i [%i]:\n',c,s);
      if kv.plot
	para.R = mosg_responsibility(X,para); % For plot only
	plot_mosg(para,X);
      end
      
      para = mosg_partialem(X,para,epsi,lambda,[s,s2]);
      iters = cat(1,iters, para.iters);
      
      fprintf(1,'Partial EM converged after %i\n',para.iters);
      if kv.plot
	plot_mosg(para,X);
      end
      
      para = mosg_fullem(X,para,epsi,lambda);
      iters = cat(1,iters, para.iters);
      
      fprintf(1,'Full EM converged after %i\n',para.iters);
      if kv.plot
	plot_mosg(para,X);
      end
      
      if (para.likely > par.likely)
	fprintf(1,'Improvement found from split candidate %i. new K is %i\n',c,s2);
	break; % out of candidate test loop
      end
    end % for split candidates
    if (para.likely > par.likely)
      par = para;
      likelies = cat(1,likelies, par.likely);
      fprintf(1,'Setting par to para from split. New K is %i\n',length(par.p));
      fail = .5;
    else
      fail = fail+1;
      next = 1;
    end
  end
      
  if (fail > 2)
    fprintf('No more improvements available after %i major iters\n',iter);
    break; % out of main loop: split nor merge produced better results
  end
end

if kv.plot
  fprintf(1,'Final result:\n');
  plot_mosg(par,X);
end
  
y=par;
[D K] = size(y.mu);
y.sig=zeros(1,K);
for k=1:K
  y.sig(k) = par.sig{k};
end
y.likelies = likelies;
y.iters = iters;
