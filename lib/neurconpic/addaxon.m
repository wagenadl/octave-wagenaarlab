function a = addaxon(typ,c1,c2,marg,dir1,dir2,linepar,synpar)
% ADDAXON - Add an axon between two cells in a NEURCONPIC graph
%    a = ADDAXON(typ,c1,c2) adds a straight axon from cell C1 to C2.
%    TYP may be 'e' or >0 for excitatory, or 'i' or <0 for inhibitory.
%    a = ADDAXON(...,marg,dir1,dir2,linepar,synpar) specifies additional
%    parameters:
%    MARG specifies how far away from cell C2 the axon ends, as a fraction
%    of cell C2's radius (default: 0.5).
%    If DIR1 may be a scalar specifying the angle at which the neurite leaves
%    cell C1, or a pair [dir, strength] specifying the angle and how far
%    out the control point will be (relative to the intersection of the
%    two lines from C1 and C2 in the specified directions).
%    DIR2 is the same for the end point of the axon. If DIR1 is given, DIR2
%    must be given also.
%    LINEPAR are additional parameters for the line making up the axon.
%    SYNPAR are for the synapse marker, which is a (circular) RECTANGLE for 
%    inhibitory, or a LINE for excitatory.

if ~ischar(typ)
  if typ>0
    typ='e';
  elseif typ<0
    typ='i';
  end
end
      
a.typ = typ;
a.c1 = c1;
a.c2 = c2;
if nargin<4
  marg=.5;
end
if nargin<5
  dir1=[];
end
if nargin<6
  dir2=[];
end
  
a.marg = marg;
a.dir1 = dir1;
a.dir2 = dir2;

if isempty(dir1) & ~isempty(dir2)
  dir1 = pi+dir2(1);
elseif isempty(dir2) & ~isempty(dir1)
  dir2 = pi+dir1(1);
end

if ~isempty(dir1)
  if length(dir1)<2
    if length(dir2)>=2
      dir1(2) = dir2(2);
    else
      dir1(2) = 1;
    end
  end
end

if ~isempty(dir2)
  if length(dir2)<2
    if length(dir1)>=2
      dir2(2) = dir1(2);
    else
      dir2(2) = 1;
    end
  end
end
  
x1 = c1.x;
y1 = c1.y;
r1 = c1.r;
x2 = c2.x;
y2 = c2.y;
r2 = c2.r;

if isempty(dir1)
  % Draw a straight line
  dx = x2-x1;
  dy = y2-y1;
  phi = atan2(dy,dx);
  x1 = x1 + cos(phi)*r1;
  x2 = x2 - cos(phi)*r2*(1+marg);
  y1 = y1 + sin(phi)*r1;
  y2 = y2 - sin(phi)*r2*(1+marg);
  a.lineh = plot([x1 x2],[y1,y2],'k');
else
  % Draw a curve with direction
  if 0
    x1 = x1 + cos(dir1(1))*r1;
    x2 = x2 + cos(dir2(1))*r2*(1+marg);
    y1 = y1 + sin(dir1(1))*r1;
    y2 = y2 + sin(dir2(1))*r2*(1+marg);
  end
  
  % Find crossing point of the two lines
  % Solve: x=x' & y=y' from
  % x = x0 + t cos(phi), y = y0 + t sin(phi),
  % x' = x0' + t' cos(phi'), y' = y0' + t' sin(phi').
  % <=>
  % x0 + t cos(phi) = x0' + t' cos(phi')
  % y0 + t sin(phi) = y0' + t' sin(phi')
  % <=>
  % sin(phi) x0 - cos(phi) y0 = 
  %       sin(phi) x0' - cos(phi) y0' + 
  %         [cos(phi') sin(phi) - sin(phi') cos(phi)] t'
  % This gives t', and hence t.
  
  t2 = (sin(dir1(1))*(x1-x2) - cos(dir1(1))*(y1-y2)) / ...
      (cos(dir2(1))*sin(dir1(1)) - sin(dir2(1))*cos(dir1(1)));
  t1 = (sin(dir2(1))*(x2-x1) - cos(dir2(1))*(y2-y1)) / ...
      (cos(dir1(1))*sin(dir2(1)) - sin(dir1(1))*cos(dir2(1)));

  dr = sqrt((x2-x1)^2 + (y2-y1)^2);
  if t1<0 | t1>dr
    t1=dr;
  end
  if t2<0 | t2>dr
    t2=dr;
  end
  
  
  c1x = x1 + cos(dir1(1))*dir1(2)*t1;
  c1y = y1 + sin(dir1(1))*dir1(2)*t1;

  c2x = x2 + cos(dir2(1))*dir2(2)*t2;
  c2y = y2 + sin(dir2(1))*dir2(2)*t2;
  
  %plot(c1x,c1y,'r.');
  %plot(c2x,c2y,'g.');
  
  xy = bezier([x1 y1],[c1x c1y],[c2x c2y],[x2 y2],1000);
  idx = find(((xy(:,1)-x1).^2+(xy(:,2)-y1).^2)>=r1^2 & ...
      ((xy(:,1)-x2).^2+(xy(:,2)-y2).^2)>=(r2*(1+marg))^2);
  xy = xy(idx,:);
  a.lineh = plot(xy(:,1),xy(:,2),'k');
  phi = dir2(1);%
  x2 = xy(end,1);
  y2 = xy(end,2);
  phi = atan2(xy(end,2)-xy(end-1,2), xy(end,1)-xy(end-1,1));
end

switch typ(1)
  case 'e'
    scl = str2num(typ(2:end));
    if isempty(scl)
      scl = .5*r2;
    end
    phi = pi/2-atan2(x2-c2.x,y2-c2.y);
    a.synh = plot(x2-[-1 1]*scl*sin(phi), y2+[-1 1]*scl*cos(phi),...
	'k', 'linew',2);
  case 'i'
    scl = str2num(typ(2:end));
    if isempty(scl)
      scl = .25*r2;
    end
    a.synh = rectangle('position',[x2-scl y2-scl 2*scl 2*scl],...
	'curvature',[1 1],'edgec','none','facec','k');
end

if nargin>=7
  set(a.lineh,linepar{:});
end
if nargin>=8
  set(a.synh,synpar{:});
end
