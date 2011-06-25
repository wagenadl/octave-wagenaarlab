function yes=elinside(el,xy)
% ELINSIDE  True if a point lies inside an ellipse
%    ELINSIDE(el,xy) returns true if the point XY lies inside the ellipse.
%    (Inside includes the edge, i.e. the test is '<=' rather than '<'.)

xi = cos(el.phi)*xy(1) + sin(el.phi)*xy(2);
eta = -sin(el.phi)*xy(1) + cos(el.phi)*xy(2);
img = xi.^2/el.R^2 + eta.^2/el.r^2 <= 1;
