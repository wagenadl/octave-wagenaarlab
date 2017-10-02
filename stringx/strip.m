function x = strip(x)
% STRIP - Remove whitespace from beginning and end of string
%   x = STRIP(x) returns X with initial and final whitespace removed

idx = find(x>' ');
if isempty(idx)
  x = '';
else
  x = x(idx(1):idx(end));
end
