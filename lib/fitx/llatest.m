xx = [0:6];
yy = exp(-xx);
x = xx(1):.05:xx(end);

figure(1); clf
dx = [.1:.1:1];
N = length(dx);
cc = djet(N);
plot(xx, yy, 'k.-', 'linewidth', 5);
hold on
for n=1:N
  plot(x, lla(xx, yy, x, dx(n)), 'color', cc(n,:));
end
nottiny

figure(2); clf
dx = [.1:.1:1];
N = length(dx);
cc = djet(N);
plot(xx, yy, 'k.-', 'linewidth', 5);
hold on
for n=2:N
  plot(x, lqa(xx, yy, x, dx(n)), 'color', cc(n,:));
end
nottiny


figure(3); clf
dx = [.1:.1:1];
N = length(dx);
cc = djet(N);
plot(xx, yy, 'k.-', 'linewidth', 5);
hold on
for n=2:N
  plot(x, lca(xx, yy, x, dx(n)), 'color', cc(n,:));
end
nottiny
