function [vc,vr]=propagationvelocity(t)
% [vc,vr]=PROPAGATIONVELOCITY(t) fits a model of linear burst
% propagation to the burst initiation times in t (a 60-vector,
% possible containing NaNs).
% Mathematics are on DW:pat.det&ana:4/01 p44v dd 10/22/01

% Here's the summary:
% chi2 = sum_rc ((r v_x + c v_y)/v^2 + t_0 - t_rc)^2.
% Define: xi==v_x/v^2; eta=v_y/v^2.
% Solve d chi2/d{xi,eta,t_0}=0:
%
% / sum r^2   sum rc    sum r \ / eta \   / sum r t_rc \
% | sum rc    sum c^2   sum c | | xi  | = | sum c t_rc |
% \ sum r     sum c     sum 1 / \ t_0 /   \ sum  t_rc  /
%
% Then invert, v_x = xi/(xi^2+eta^2); v_y = eta/(xi^2+eta^2).

cr = hw2crd([0:59]);
c = floor(cr/10);
r = mod(cr,10);
bad = isnan(t); good=[1:60]; good(bad)=0; good=find(good);
A=zeros(3,3);
A(1,1)=sum(r(good).^2);
A(2,1)=sum(r(good).*c(good)); A(1,2)=A(2,1);
A(3,1)=sum(r(good));          A(1,3)=A(3,1);
A(2,2)=sum(c(good).^2);
A(3,2)=sum(c(good));          A(2,3)=A(3,2);
A(3,3)=length(good);
B=zeros(3,1);
B(1)=sum(r(good).*t(good));
B(2)=sum(c(good).*t(good));
B(3)=sum(t(good));
V = inv(A)*B;
V2 = V(1)^2 + V(2)^2;
vr = V(1)/V2;
vc = V(2)/V2;
