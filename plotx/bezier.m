function x = bezier(p0,c0,c1,p1,n)
% x = BEZIER(p0,c0,c1,p1) creates a Bezier curve from P0 to P1 
% with control points C0 and C1. All in 2D.
% x = BEZIER(...,n) specifies number of output points.

% Taken from http://www.ece.uvic.ca/~btill/20004/bezier.m

if nargin<5
  N=100;
else
  N=n;
end

G = [p0(:) c0(:) c1(:) p1(:)]';

% u = column vector [1 2 3 .... N]'/N
%u=(1:N)'/N;
u=(0:N-1)'/(N-1);

  U = [u.^3 u.^2 u.^1 u.^0]; 
% U = N by 4 matrix with 4 column vectors 
% u.^2 means each element of 
% the column vector u is squared (help punct)
% ones(N,1) is a matrix of 1's with N rows, 1 column
% can also write 
% U = [u.^3 u.^2 u ones(N,1)];

% Bezier coefficient matrix B_k,n 
% for 4 control points (n=3)
B=[-1  3 -3  1;
    3 -6  3  0;
   -3  3  0  0;
    1  0  0  0];
 
 % find Bezier curve using notes page 87
 P=U*B*G;
 
 %P = N by 2 matrix of N points (x,y) on Bezier curve
 %G = N by 2 matrix of 4 control points (x.y)
 
%P(:,1) is column 1 of P (all x values)
%P(:,2) is column 2 of P (all y values)

x = P;
