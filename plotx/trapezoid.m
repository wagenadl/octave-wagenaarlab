function h=trapezoid(tx,ty,bx,by,fc,lc)
% h = TRAPEZOID(tx,ty,bx,by,fc,lc) draws a trapezoid.
% TX is a 2-vector of top X-coordinates. TY is the top Y-coordinate.
% BX is a 2-vector of bottom X-coordinates. TY is the bottom Y-coordinate.
% FC (optional) defines the face color
% LC (optional) defines the edge color of the standing edges
% Returns a tructure with members:
%
%  S: handle of the face
%  L: handles of the standing edges

if nargin<5 | isempty(fc)
  fc = [.8 .8 .8];
end
if nargin<6 | isempty(lc)
  lc = .5 * fc;
end

ho=ishold;
hold on

h.s=surf([tx(:) bx(:)],[ty by; ty by],[-1 -1; -1 -1]);
set(h.s,'facecolor',fc);
set(h.s,'edgecolor','none');

h.l(1) = line([tx(1) bx(1)],[ty by]);
h.l(2) = line([tx(2) bx(2)],[ty by]);
set(h.l,'color',lc);

if ~ho
  hold off
end
