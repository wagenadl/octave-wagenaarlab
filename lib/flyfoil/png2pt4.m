function png2pt4(ifn, ofn, varargin)
% PNG2PT4 - Convert a PNG file with a closed curve to a PT4 file for milling
%    PNG2PT4(ifn, ofn) converts a PNG file with a single closed curve
%    to a PT4 file for the Prototrak mill.
%    PNG2PT4(ifn, ofn, key, value, ...) specifies options:
%      dpi - resolution of original file (default: 9000 dpi)
%      diam - diameter of end mill (default: 0.010")
%      tol - tolerance factor (default: 1; larger is coarse approximation)
%      plot - flag to select plotting of extracted curve (default: 1)
%      zrapid - Z position above material (default: 0.005")
%      zend - Z position in material (default: -0.002")
%      passes - number of steps to reach zend from zrapid (default: 1)
%      feed - cutting feed rate (default: 0.1 in/min, which is very slow)
%      rpm - cutting speed (default: 5000 rpm)
%      
%    The curve must be presented as light-on-dark. This is achieved 
%    automatically if the curve is presented as solid-on-transparent.
%    The center of the curve is used as the outside of the cut.

kv = getopt('dpi=9000 diam=0.010 tol=1 plot=1 zrapid=.005 zend=-.002 feed=.1 rpm=5000 passes=1', varargin);

if nargin<2
  [p, b, e] = fileparts(ifn);
  ofn = [p filesep b '.pt4'];
end

[xx, yy] = tracefoil(ifn, kv.dpi, 1);
arcs = trace2arcs(xx, yy, 2*kv.tol/kv.dpi, 1);
arco = shrinkarcs(arcs, kv.diam, kv.plot);

arcs2pt4(arco, ofn);
