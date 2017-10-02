function J = mog_mergemerit(X,par,R)
% MOG_MERGEMERIT computes the merge merit matrix for MoG SMEM
% Input: X, par: as for mog_fullem
%        R: NxK responsibility matrix as from mog_responsibility
% Output: KxK symmetric matrix of merge merits
% Algorithm: Ueda et al
% Coding: DW

J = R'*R;
