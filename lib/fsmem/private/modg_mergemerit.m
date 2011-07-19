function J = modg_mergemerit(X,par,R)
% MODG_MERGEMERIT computes the merge merit matrix for Modg SMEM
% Input: X, par: as for modg_fullem
%        R: NxK responsibility matrix as from modg_responsibility
% Output: KxK symmetric matrix of merge merits
% Algorithm: Ueda et al
% Coding: DW

J = R'*R;
