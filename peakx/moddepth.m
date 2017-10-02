function pkpos = moddepth(yy,depth)
% pkpos = MODDEPTH(yy,depth) finds maxima in YY that are at least DEPTH above
% the surrounding minima.

N=length(yy);
pkpos=[];
lastmin_i=0;
lastmin_v=inf;
lastmax_i=0;
lastmax_v=-inf;
gotcha=0;
for n=1:N
  v=yy(n);
  if v<lastmin_v
    lastmin_i=n;
    lastmin_v=v;
    if (lastmax_v>=v+depth) & gotcha
      pkpos = [pkpos lastmax_i];
      lastmax_i=0;
      lastmax_v=-inf;
      gotcha=0;
    end
  end
  if v>lastmax_v
    lastmax_i=n;
    lastmax_v=v;
    if v>=lastmin_v+depth
      gotcha=1;
      lastmin_i=0;
      lastmin_v=inf;
    end
  end
end
if (lastmax_v>=lastmin_v+depth) & gotcha
  pkpos = [pkpos lastmax_i];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function test_md
[b,a]=lowpass1(.01);
yy=filtfilt(b,a,randn(10000,1));
yy=yy(50:end-50);
figure(1); clf
plot(yy,'.-');
pk=moddepth(yy,.3);
hold on
plot(pk,yy(pk),'b*');
no=extendpeaks(yy,pk,.2);
hold on
zz=yy; zz(~no)=nan;
plot(zz,'r');
