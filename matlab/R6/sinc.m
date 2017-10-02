function y = sinc(x)
% SINC - Calculates sin(pi*x)/(pi*x)

idx=find(x==0);
x(idx)=1; % Avoid warnings of 0/0.

y = sin(pi*x)./(pi*x);
y(idx)=1;
