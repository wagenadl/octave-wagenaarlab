function pngs2pt4(dir, varargin)
% PNGS2PT4 - Convert a whole folder worth of PNGs to PT4
%   PNGS2PT4(dir) converts all PNGs in DIR to PT4 using PNG2PT4.
%   PNGS2PT4(dir, key, value, ...) specifies additional options
%   as per PNG2PT4.

if nargin==0
  dir = '.';
end

fns = glob([dir filesep '*.png']);
F = length(fns);
for f=1:F
  ifn = fns{f};
  [d,b,e] = fileparts(ifn);
  ofn = [d filesep b '.pt4' ];
  printf('Converting %s to %s\n', ifn, ofn);
  png2pt4(ifn, ofn, varargin);
end
