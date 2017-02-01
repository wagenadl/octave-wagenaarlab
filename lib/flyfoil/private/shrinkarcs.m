function arcout = shrinkarcs(arcs, diam, pltflg)
% SHRINKARCS - Shrink arcs to accommodate an end mill of given diameter
%   arcs = SHRINKARCS(arcs, diam) shrinks the curve given by ARCS (from
%   TRACEFOIL) inward so that it can be fed to the ProtoTRAK as a "tool
%   center" path.

if nargin<3
  pltflg = 0;
end
if nargout==0
  pltflg = 1;
end

% Let's first get all the control points. By construction, an arc's start
% point is the previous end point, and the last end point is the first
% start point.

ctrlx = [arcs.xs; arcs.xs(1)]; % circular definition
ctrly = [arcs.ys; arcs.ys(1)]; % circular definition
% For the angles, let's average the angles of both touching segments:
ctrlphi1 = [arcs.phis; arcs.phis(1)];
ctrlphi2 = [arcs.phie(end); arcs.phie];
ctrlphi = arg(exp(i*ctrlphi1) + exp(i*ctrlphi2));

% Now, let's shrink toward the center
ctrlx = ctrlx - diam/2 * cos(ctrlphi);
ctrly = ctrly - diam/2 * sin(ctrlphi);

if pltflg
  hold on
  h = plot(ctrlx, ctrly, 'k*'); nottiny;
end

% Let's get some intermediate points as well
interphi = arg(exp(i*arcs.phis) + exp(i*arcs.phie));
interx = arcs.xc + arcs.R .* cos(interphi);
intery = arcs.yc + arcs.R .* sin(interphi);
% And shrink those
interx = interx - diam/2 * cos(interphi);
intery = intery - diam/2 * sin(interphi);

if pltflg
  h1 = plot(interx, intery, 'r*'); nottiny;
end

% Segments with R <~ diam/2 are problematic.
% We'll replace sequences of such segments with two new segments that join
% at a newly invented vertex.


ctrlxo = zeros(0,1);
ctrlyo = zeros(0,1);
interxo = zeros(0,1);
interyo = zeros(0,1);
ctrlxo(end+1) = ctrlx(1);
ctrlyo(end+1) = ctrly(1);

k = 1;
K = length(interx);
while k<=K
  if k==K || arcs.R(k+1)>diam/2
    % That's easy
    interxo(end+1) = interx(k);
    interyo(end+1) = intery(k);
    ctrlxo(end+1) = ctrlx(k+1);
    ctrlyo(end+1) = ctrly(k+1);
    k = k + 1;
  else
    l = k+1;
    while l<=K && arcs.R(l)<=diam/2
      l = l+1;
    end
    k
    l
    % So segments k+1...l-1 are problematic.
    % We'll replace segments k...l with a new pair

    inter1 = [interx(k) intery(k)];
    vertex = [mean(ctrlx(k+1:l)) mean(ctrly(k+1:l))];
    inter2 = [ interx(l) intery(l)];
    pre = [ctrlx(k) ctrly(k)];
    post = [ctrlx(l+1) ctrly(l+1)];
    
    if 0
      % Following prevents concave segments
      % To use this, I need to learn how to make straight lines 
      % on the prototrak in PT4 code.
      if sa_cross(inter1-pre, vertex-pre) < 0
        inter1 = (vertex + pre)/2;
      end
      if sa_cross(inter2-vertex, post-vertex) < 0
        inter2 = (vertex + post)/2;
      end
    end

    interxo(end+1) = inter1(1);
    interyo(end+1) = inter1(2);
    
    ctrlxo(end+1) = vertex(1);
    ctrlyo(end+1) = vertex(2);

    interxo(end+1) = inter2(1);
    interyo(end+1) = inter2(2);

    ctrlxo(end+1) = ctrlx(l+1);
    ctrlyo(end+1) = ctrly(l+1);
    
    k = l + 1;
  end
end

if pltflg
  figure(2); clf
  plotarcs(arcs);
  hold on
  h = plot(ctrlxo, ctrlyo, 'k*'); nottiny;
  h1 = plot(interxo, interyo, 'r*'); nottiny;
  a=max(abs(axis))
  axis([-a a -a a])
  axis square;
end

N = length(interxo);
for n=1:N
  arcout.xs(n) = ctrlxo(n);
  arcout.ys(n) = ctrlyo(n);  
  arcout.xe(n) = ctrlxo(n+1);
  arcout.ye(n) = ctrlyo(n+1);
  [p0 R] = circlefrom3([arcout.xs(n) arcout.ys(n)], ...
      [interxo(n) interyo(n)], ...
      [arcout.xe(n) arcout.ye(n)]);
  arcout.xc(n) = p0(1);
  arcout.yc(n) = p0(2);
  arcout.R(n) = R;
end

arcout.phis = atan2(arcout.ys-arcout.yc, arcout.xs-arcout.xc);
arcout.phie = atan2(arcout.ye-arcout.yc, arcout.xe-arcout.xc);

if pltflg
  figure(pltflg); clf
  plotarcs(arcs);
  hold on
  h = plot(ctrlxo, ctrlyo, 'k*'); nottiny;
  h1 = plot(interxo, interyo, 'r*'); nottiny;
  plotarcs(arcout); nottiny;
  a=max(abs(axis))
  axis([-a a -a a])
  axis square;
end

if nargout==0
  clear arcout
end

function z = sa_cross(v1, v2)
z = v1(1)*v2(2) - v1(2)*v2(1);
