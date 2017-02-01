function [R, phie] = tf_bestarc(xx, yy, xs, ys, phis)
% TF_BESTARC - Fit an arc to some data
%   xx, yy are data points. 
%   xs, ys is the beginning of the arc
%   phis is the tangent angle at the beginning.

whos

p = fminsearch(@(p) (tf_testarc(xx,yy,xs,ys,phis, p(1), p(2))), [phis+.1, 1]);
phie = p(1);
R = p(2);
