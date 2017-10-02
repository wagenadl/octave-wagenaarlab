% Tools for manipulation of ellipses
% Copyright (C) Daniel Wagenaar 2006 <dwagenaar@ucsd.edu>
%
% Plot functions:
%
%   ELPLOT_XYRRA - Plot ellipse defined by center, radii and angle.
%   ELPLOT_XYABC - Plot ellipse defined by center and covariance matrix.
%
% Representation conversion functions:
%
%   ELRRA2ABC       - Convert from radii and angle repr. to covariance repr.
%   ELABC2RRA       - Convert from covariance repr. to radii and angle repr.
%   ELBUILD_XYRRA   - Construct radii and angle repr. from vector
%   ELEXTRACT_XYRRA - Extract 1x5 vector from radii and angle repr.
%
% Mouse interaction functions:
%
%   ELDRAG_CENTER - Let the center of a radii-and-angle ellipse be moved.
%   ELDRAG_ROTATE - Let a radii-and-angle ellipse be rotated.
%   ELDRAG_RESIZE - Let a radii-and-angle ellipse be deformed.
%
% Other functions (mainly for internal use):
%
%   ELFIND_NEAREST - Find nearest point on a radii-and-angle ellipse.
%   ELMAXY         - Find highest point on a radii-and-angle ellipse.
%   ELPARALLEL     - Find parallel to a given point on an r&a ellipse.
%
% Representations:
%
% 1. Radii and angle ("xyrra"):
%
%       |x|     |x0|   |cos(phi) -sin(phi)|  |xi |
%       | |  =  |  | + |                  |  |   | ,
%       |y|     |y0|   |sin(phi)  cos(phi)|  |eta|
% 
%     where:
% 
%       |xi |    |R cos(omega)|
%       |   |  = |            | .
%       |eta|    |r sin(omega)|
%
% 2. Covariance:
%                   2               2
%       alpha (x-x0)  +  beta (y-y0)  +  2 gamma (x-x0) (y-y0)  =  1 .
