function plotarcs(arcs)
hold on
N = length(arcs.R);
cc = djet(N);
for n=1:N
  plot(arcs.xs(n), arcs.ys(n), '+', 'color', cc(n,:));
  plot(arcs.xe(n), arcs.ye(n), 'x', 'color', cc(n,:));  
  s = arcs.phis(n);
  e = arcs.phie(n);
  if mod(e-s, 2*pi)>=pi
    [s, e] = identity(e, s);
  end
  if e<s
    e = e + 2*pi;
  end
  phi = [s:.001:e];

  plot(arcs.xc(n)+arcs.R(n)*cos(phi), arcs.yc(n)+arcs.R(n)*sin(phi), ...
      'color', cc(n,:));  
end

  