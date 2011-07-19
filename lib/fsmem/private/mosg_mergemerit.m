function J = mosg_mergemerit(X,par,R)
% MOSG_MERGEMERIT computes the merge merit matrix for Mosg SMEM
% Input: X, par: as for mosg_fullem
%        R: NxK responsibility matrix as from mosg_responsibility
% Output: KxK symmetric matrix of merge merits
% Algorithm: Ueda et al
% Coding: DW

J = R'*R;
