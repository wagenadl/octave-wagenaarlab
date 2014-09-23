function clr=bluered(n,xt,th1,th2)
% clr = BLUERED returns a graded flag colormap
% clr = BLUERED(n) specifies the number of gradations
% clr = BLUERED(n,xt) adds a fraction XT of dark to the spectrum, where XT=0-1.
% clr = BLUERED(n,xt,th1) shifts the entire map by TH1 degrees
% clr = BLUERED(n,xt,th1,th2) shifts the red part of the map by TH1 degrees,
%                             and the blue part by TH2 degrees.

if nargin<1
  n=100;
end
if nargin<3
  th1=0;
end
if nargin<4
  th2=th1;
end
up=[0:1/n:1]';
dn=flipud(up);
z0=0*up;
z1=z0+1;


if nargin>1
  upa = up(max([1 ceil(n.*(1-xt))]):end);
  dna = flipud(upa);
  z0a=0*upa;
  z1a=0*upa+1;
  clr = [z0a z0a upa; up up z1; z1 dn dn; dna z0a z0a];
else
  clr = [up up z1; z1 dn dn];
end

N=size(clr,1)/2;
clr=[rotacol(clr(1:N,:),th2/180*pi); rotacol(clr(N+1:end,:),th1/180*pi)];
