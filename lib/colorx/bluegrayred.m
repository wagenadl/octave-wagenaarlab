function clr=bluegrayred(n, f)
% BLUEGRAYRED - Generate a colormap with grays, blues, and reds
%    clr = BLUEGRAYRED generates a colormap with white-to-black in the middle, 
%    blues at the lower end, and reds at the upper end.
%    clr = BLUEGRAYRED(n, f) specifies the total number of entries and the
%    fraction at each of the ends. By default, f=0.25, so half the map is 
%    gray scale.

if nargin<2
  f=0.25;
end
if nargin<1
  n=100;
end

n1=ceil(f*n);
n0=n-2*n1;
c1=[0:n1-1]'/(n1-1);
c0=[0:n0-1]'/(n0-1);

o1=0*c1;
o0=0*c0;
i1=o1+1;
i0=o0+1;

clr = [ i1 c1 o1; c0 c0 c0; o1 c1 i1];
clr = flipud(clr);
