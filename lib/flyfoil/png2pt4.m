function [nextrec, nextevt] = png2pt4(ifn, ofn, varargin)
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
%      color - RGB triplet to select (default: none, select any)
%      startrec - starting record number (for continuing a previous file)
%      startevt - starting event number  (for continuing a previous file)
%
%    [nextrec, nextevt] = PNG2PT4(...) returns starting record and event
%    numbers for a continuation run. In this case, no footer is written.
%    At the moment, each run in a series must use the same mill. Different
%    depths are allowed.
%      
%    The curve must be presented as light-on-dark. This is achieved 
%    automatically if the curve is presented as solid-on-transparent.
%    The center of the curve is used as the outside of the cut.

kv = getopt('dpi=9000 diam=0.010 tol=1 plot=1 zrapid=.005 zend=-.002 feed=.1 rpm=5000 passes=1 color=[] firstrec=1 firstevt=56', varargin);

if nargin<2
  [p, b, e] = fileparts(ifn);
  ofn = [p filesep b '.pt4'];
end

[xx, yy] = tracefoil(ifn, kv.dpi, kv.color, kv.plot);
arcs = trace2arcs(xx, yy, 2*kv.tol/kv.dpi, kv.plot);
arco = shrinkarcs(arcs, kv.diam, kv.plot);

if nargout>=2
  [nextrec, nextevt] = arcs2pt4(arco, ofn, kv);
else
  arcs2pt4(arco, ofn, kv);
end
