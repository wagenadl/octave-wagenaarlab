function [r,c] = subplots(f)
% [r,c] = SUBPLOTS(f) finds a reasonable number of rows and columns for
% a graph to have F subplots. Guarantee: R>=C; RC>=F.

r=ceil(sqrt(f));
c=ceil(f/r);
if r<c
  [r,c]=swap(r,c);
end
