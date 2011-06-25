function y=sneo(x)
% y=SNEO(x) performs SNEO filtering as in meabench/spikesrv/SD_SNEO.H
x1=slowone(x);
x2=slowone(x1);
%d1=x-x1;
%d2=x+x2-2*x1;
y=x1.*x1 - x.*x2;
y=convo(y);
y=convo(y);
return;

function y=slowone(x)
b=[ 0 1 ];
a=[ 1 0 ];
y=filter(b,a,x);
return;

function y=convo(x)
b=[ 1 1 1 ];
a=[ 5 0 0 ];
y=filter(b,a,x);
return
