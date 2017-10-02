function plotarcs(arcs)
hold on
N = length(arcs.R);
cc = djet(N);
for n=1:N
  plot(arcs.xs(n)*25.4, arcs.ys(n)*25.4, '+', 'color', cc(n,:));
  plot(arcs.xe(n)*25.4, arcs.ye(n)*25.4, 'x', 'color', cc(n,:));  
  s = arcs.phis(n);
  e = arcs.phie(n);
  if mod(e-s, 2*pi)>=pi
    [s, e] = identity(e, s);
  end
  if e<s
    e = e + 2*pi;
  end
  phi = [s:.001:e];

  plot((arcs.xc(n)+arcs.R(n)*cos(phi))*25.4, ...
      (arcs.yc(n)+arcs.R(n)*sin(phi))*25.4, ...
      'color', cc(n,:));  
end

  