function t=inv_t(p,df)
% INV_T - Inverse cdf for Student's t distribution
%   tt = INV_T(pp,df) returns the inverse cdf for the t distribution 
%   with DF degrees of freedom at (cumulative) probabilities PP.
%
%   This version uses a table. For p-values not in the table, the
%   next higher value in the table is used if p>0.5, or the next lower value
%   if p<0.5. This makes the output be at least as large in absolute value
%   as the true number.
%   If df>100, a normal approximation is made; the table is not used. This,
%   unfortunately, makes the number at most as large in absolute value
%   as the true number.

t = tinv(p, df);
