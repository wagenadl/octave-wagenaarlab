function d=propagationvelocity(t,w)
% d=PROPAGATIONDELAY(t,w) fits a model of linear burst
% propagation to the burst initiation times in t (a 60-vector,
% possible containing NaNs).
% If specified, w is a vector of weights for each electrode.
% Mathematics are on DW:pat.det&ana:4/01 p44v dd 10/22/01

% Here's the summary:
% chi2 = sum_rc (c d1 + r d2 + t_0 - t_rc)^2.
% Solve dchi2/d{d1,d2}=0:
%
% / sum r^2   sum rc    sum r \ / d2 \   / sum r t_rc \
% | sum rc    sum c^2   sum c | | d1  | = | sum c t_rc |
% \ sum r     sum c     sum 1 / \ t_0 /   \ sum  t_rc  /
%
% Then invert, v_x = xi/(xi^2+eta^2); v_y = eta/(xi^2+eta^2).

if nargin<2
  w=ones(1,60);
end
cr = hw2crd([0:59]);
c = floor(cr/10);
r = mod(cr,10);
bad = isnan(t); good=[1:60]; good(bad)=0; good=find(good);
A=zeros(3,3);
A(1,1)=sum(w(good).*r(good).^2);
A(2,1)=sum(w(good).*r(good).*c(good)); A(1,2)=A(2,1);
A(3,1)=sum(w(good).*r(good));          A(1,3)=A(3,1);
A(2,2)=sum(w(good).*c(good).^2);
A(3,2)=sum(w(good).*c(good));          A(2,3)=A(3,2);
A(3,3)=sum(w(good));
B=zeros(3,1);
B(1)=sum(w(good).*r(good).*t(good));
B(2)=sum(w(good).*c(good).*t(good));
B(3)=sum(w(good).*t(good));
V = inv(A)*B;
d=[V(2) V(1)];