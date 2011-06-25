function plotclust(x0,y0,xx,yy,xy,opts_pt,opts_cir,txt)
% PLOTCLUST(x0,y0,xx,yy,xy,opts_pt,opts_cir,txt) plots a
% representation of the cluster with centroid (x0,y0) and covariance
% matrix [xx xy; xy yy]. The center is represented with a dot with
% plot options opts_pt; the 1 sigma ellips is plotted using
% opts_cir.
% OPTS_PT, OPTS_CIR can be omitted, default is 'b'.
% If the optional argument TXT is present, no centroid dot is
% plotted, but the given TXT is plotted at the centroid position
% instead, using the *color* in opts_pt.
if nargin<6
  opts_pt='b';
end
if nargin<7
  opts_cir=opts_pt;
end
phi=[0:.1:(2*pi+.1)];
cs = [cos(phi); sin(phi)];
[ U S V ] = svd([xx xy; xy yy]);
cs=U*sqrt(S)*V*cs;

if nargin==8
  plot(x0+cs(1,:),y0+cs(2,:),opts_cir);
  a=text(x0,y0,txt);
  set(a,'color',opts_pt);
  set(a,'horizontalalignment','center');
  set(a,'verticalalignment','middle');
else
  plot(x0,y0,opts_pt,  x0+cs(1,:),y0+cs(2,:),opts_cir);
end
