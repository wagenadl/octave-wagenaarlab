function u = outer(v,w)
% OUTER  Cross product between vectors in 3D space.
%   u = OUTER(v,w) computes the outer (hat) product between a pair of
%   3D vectors. This also works for 3xN arrays, which are treated column
%   by column.
%   (Note that it also works on 1x3 vectors, which are treated as if they
%   were 3x1.)

A=size(v,1);
if A==1
  v=v';
  w=w';
end

u=zeros(size(v));
u(1,:) = v(2,:).*w(3,:) - v(3,:).*w(2,:);
u(2,:) = v(3,:).*w(1,:) - v(1,:).*w(3,:);
u(3,:) = v(1,:).*w(2,:) - v(2,:).*w(1,:);

if A==1
  u=u';
end
