function arcs = fitarcs(xx, yy, eps)
L = length(xx);
L2 = round(L/2);
p1 = [xx(1) yy(1)];
p2 = [xx(L2) yy(L2)];
p3 = [xx(L) yy(L)];
[p0 R] = circlefrom3(p1, p2, p3);

phi = [0:.0001:2*pi];
x_ = p0(1) + R*cos(phi);
y_ = p0(2) + R*sin(phi);
ok = 1;
if L>5
  for k=1:L
    bst = min((xx(k)-x_).^2 + (yy(k)-y_).^2);
    if bst > eps.^2
      ok = 0;
      break;
    end
  end
end

if ok
  arcs.xc = p0(1);
  arcs.yc = p0(2);
  arcs.R = R;
  arcs.xs = xx(1);
  arcs.ys = yy(1);
  arcs.xe = xx(L);
  arcs.ye = yy(L);
  arcs.phis = atan2(arcs.ys-arcs.yc, arcs.xs-arcs.xc);
  arcs.phie = atan2(arcs.ye-arcs.yc, arcs.xe-arcs.xc);
else
  arc1 = fitarcs(xx(1:L2), yy(1:L2), eps);
  arc2 = fitarcs(xx(L2:end), yy(L2:end), eps);  
  arcs = catstr(arc1, arc2);
end
