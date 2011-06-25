function [mn,mx] = nearminmax(xx,frac,marg)
% [mn,mx] = NEARMINMAX(xx,frac,marg) takes the FRAC-th and (1-FRAC)-th
% fractile of the data in XX, and extends the resulting range by a 
% fraction MARG.
% Note: a "fractile" is like a percentile, except ranging 0..1 rather
% than 0..100.

xx = sort(xx);
[L N] = size(xx);
mn = xx(ceil(L*frac),:);
mx = xx(ceil(L*(1-frac)),:);
rn = mx-mn;
mn = mn - marg * rn;
mx = mx + marg * rn;
