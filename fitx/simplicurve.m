function xy = simplicurve(xy0,sigs,PLOTFLG)
% SIMPLICURVE - Simplify a curve in 2D space
%    xy = SIMPLICURVE(xy0,sigma) takes the Nx2 curve specified by XY0 and
%    simplifies it as follows:
%    First, XY0 is passed through a Gaussian smoothing filter with
%    width SIGMA. The result of this is not adequate because of two reasons:
%    (1) If the original curve is like a circular arc, the smoothing will
%    "pull" toward the center, and (2) the smoothing will pull the curve
%    inward (along the curve) from the end points.
%    Problem (1) is resolved by calculating the orthogonal distance between
%    the smoothed curve and the original curve, and balancing it out. Then,
%    problem (2) is resolved by shifting each point of the (new) smoothed
%    curve along the curve to minimize the distance to the original point.
%    If SIGS is a vector, the algorithm is iterated several times.

if nargin<3
  PLOTFLG=0;
end

[L,D] = size(xy0);

xy1=xy0;

for s=1:length(sigs)
  % First, smooth it
  xy1 = gsmooth(xy1,abs(sigs(s)));

  % Find direction of curve and bring parallel to orig.
  dxy = diff(xy1);
  dxy = ([dxy(1,:); dxy] + [dxy; dxy(end,:)])/2;
  if sigs(s)<0
    dst=min([0:L-1],[L-1:-1:0])';
    amt=exp(-.5*dst.^2/abs(sigs(s)).^2);
  else
    amt=ones(L,1);
  end
  dxy = dxy ./ repmat(sqrt(sum(dxy.^2,2)),[1 2]);
  dist = xy0 - xy1;
  proj = sum(dist.*dxy,2);
  xy1 = xy1 + repmat(proj.*amt,[1 2]).*dxy;
    
  if sigs(s)>0
  
    % Find direction of curve, and balance out orthogonals
    dxy = diff(xy1);
    dxy = ([dxy(1,:); dxy] + [dxy; dxy(end,:)])/2;
    dxy = dxy ./ repmat(sqrt(sum(dxy.^2,2)),[1 2]);
    ortho = [-dxy(:,2) dxy(:,1)];
    dist = xy0 - xy1;
    proj = sum(dist.*ortho,2);
    shft = sum(proj) / size(xy0,1);
    xy1 = xy1 + repmat(shft,[L D]).*ortho;
  
  end
end
  
xy = xy1;