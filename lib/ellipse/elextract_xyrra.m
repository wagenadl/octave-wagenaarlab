function xyrra = elextract_xyrra(el)
% ELEXTRACT_XYRRA  Decodes a XYRRA struct
%    xyrra = ELEXTRACT_XYRRA(el) takes an ellipse in xyrra form and returns
%    the parameters as a 1x5 vector.

xyrra = [el.x0 el.y0 el.R el.r el.phi];

