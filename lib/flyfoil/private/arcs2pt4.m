function arcs2pt4(arcs, ofn, varargin)
% ARCS2PT4 - Convert a series of arcs to a PT4 file for the ProtoTRAK
%    ARCS2PT4(arcs, ofn) converts a series of arcs (from TRACEFOIL or
%    SHRINKARCS) to a ".pt4" file for the ProtoTRAK mill.
%    ARCS2PT4(arcs, ofn, key, value, ...) specifies additional options:
%      diam - diameter of end mill (default: 0.010")
%      zrapid - Z position above material (default: 0.005")
%      zend - Z position in material (default: -0.002")
%      passes - number of steps to reach zend from zrapid (default: 1)
%      feed - cutting feed rate (default: 0.1 in/min, which is very slow)
%      rpm - cutting speed (default: 5000 rpm)

kv = getopt('diam=0.010 zrapid=.005 zend=-.002 feed=.1 rpm=5000 passes=1', varargin);

fd = fopen(ofn, 'wb');
if fd<0
  error('Cannot write output');
end

global a2p_rec
a2p_rec = 1;

header(fd, ofn);
tooltable(fd, kv);
fixturetable(fd, kv);

events(fd, arcs, kv);

fclose(fd);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function header(fd, ofn)
section(fd, 'HEADER');
begrec(fd);
[d,n,e] = fileparts(ofn);
keyval(fd, 'NAME', sprintf('D:\\%s.PT4', toupper(n)));
keyval(fd, 'VERSION', '5.11 (103114.09 1980)');
keyval(fd, 'FIRMWARE', 'SLV 4.6.7 SX');
keyval(fd, 'PRODUCT', "54\tPROTOTRAK SX");
keyval(fd, 'SCALE', 1.0);
keyval(fd, 'METRIC_DISPLAY', '0');
keyval(fd, 'USE_DWELL', '0');
keyval(fd, 'USE_AUX', '0');
keyval(fd, 'USE_COMMENTS', '0');
keyval(fd, 'IS_TOOLPATH', '1');
keyval(fd, 'IS_SPINDLEOFF', '1');
keyval(fd, 'EVENT_GROUP', '1');
keyval(fd, 'X_HOME', 0);
keyval(fd, 'Y_HOME', 0);
keyval(fd, 'USE_FIXTURE', "\t0");
endrec(fd);
endsec(fd);

function tooltable(fd, kv)
section(fd, 'TOOLTABLE');
begrec(fd);
keyval(fd, 'TOOL', '1');
keyval(fd, 'TYPE', '4');
keyval(fd, 'DIAMETER', kv.diam * 25.4);
keyval(fd, 'ZOFFSET', 0);
keyval(fd, 'ZMOD', 0);
endrec(fd);
endsec(fd, 1);

function fixturetable(fd, kv);
section(fd, 'FIXTURETABLE');
endsec(fd, 1);

function events(fd, arcs, kv)
section(fd, 'EVENTS');
begrec(fd);
keyval(fd, 'EVENT', '56');
keyval(fd, 'TYPE', "14\tIRR PROFILE");
keyval(fd, 'OK', '1');
abskey(fd, 'XBEG', arcs.xs(1));
abskey(fd, 'YBEG', arcs.ys(1));
abskey(fd, 'ZRAPID', kv.zrapid*25.4);
abskey(fd, 'ZEND', kv.zend*25.4);
keyval(fd, 'TOOL_OFFSET', '0');
keyval(fd, 'PASSES', sprintf('%i', kv.passes));
keyval(fd, 'ZFEEDRATE', kv.feed*25.4);
keyval(fd, 'FEEDRATE', kv.feed*25.4);
keyval(fd, 'FINCUT', 0);
keyval(fd, 'FINFEEDRATE', 0);
keyval(fd, 'RPM', kv.rpm);
keyval(fd, 'FINRPM', 0);
keyval(fd, 'TOOL', '1');
keyval(fd, 'AUXBEG', '0');
keyval(fd, 'AUXEND', '0');
keyval(fd, 'COMMENT', '');
keyval(fd, 'FIXTURE', '0');
endrec(fd);

global a2p_evt
a2p_evt = 57;
K = length(arcs.xs);
for k=1:K
  arcevent(fd, subset(arcs, [1:K]==k));
end

endsec(fd, 1);

function arcevent(fd, arc)
global a2p_evt
begrec(fd);
keyval(fd, 'EVENT', sprintf('%i', a2p_evt));
a2p_evt = a2p_evt + 1;
keyval(fd, 'TYPE', "16\tA.G.E. ARC");
keyval(fd, 'OK', '0');
keyval(fd, 'TANGENT', '2');
dphi = mod(arc.phie-arc.phis, 2*pi);
if dphi>=pi
  keyval(fd, 'ARCDIR', '1');
else
  keyval(fd, 'ARCDIR', '2');
end
abskey(fd, 'XEND', arc.xe);
abskey(fd, 'YEND', arc.ye);
abskey(fd, 'XCENT', arc.xc);
abskey(fd, 'YCENT', arc.yc);
keyval(fd, 'CONRAD', 0);
keyval(fd, 'RADIUS', 25.4*arc.R);
if dphi>=pi
  dphi = 2*pi - dphi;
end
keyval(fd, 'CHORD_LENGTH', dphi * 25.4 * arc.R);
keyval(fd, 'CHORD_ANGLE', dphi * 180/pi);
keyval(fd, 'TANGENT_SRC', '0');
keyval(fd, 'ARCDIR_SRC', '1');
keyval(fd, 'XEND_SRC', '1');
keyval(fd, 'YEND_SRC', '1');
keyval(fd, 'XCENT_SRC', '2');
keyval(fd, 'YCENT_SRC', '2');
keyval(fd, 'CONRAD_SRC', '0');
keyval(fd, 'RADIUS_SRC', '1');
keyval(fd, 'CHORD_LENGTH_SRC', '2');
keyval(fd, 'CHORD_ANGLE_SRC', '2');
guessval(fd, 'XCENT', arc.xc);
guessval(fd, 'YCENT', arc.yc);
guessval(fd, 'XEND');
guessval(fd, 'YEND');
endrec(fd);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function section(fd, name)
fprintf(fd, '--------------------------\n');
fprintf(fd, 'SECTION\t\t%s\n', name);

function begrec(fd)
global a2p_rec;
fprintf(fd, '--------------------------\n');
fprintf(fd, 'BEGREC\t\t%i\n', a2p_rec);
a2p_rec = a2p_rec + 1;

function keyval(fd, key, val)
if length(key)<8
  key = [key "\t"];
end

if ischar(val)
  fprintf(fd, '%s\t%s\n', key, val);
else
  fprintf(fd, '%s\t%.6f\n', key, val);
end

function endrec(fd)
fprintf(fd, 'ENDREC\n');

function endsec(fd, empty)
if nargin>=2 && empty
  fprintf(fd, '--------------------------\n');
end
fprintf(fd, 'ENDS\n');

function abskey(fd, key, val)
keyval(fd, key, sprintf('%.6fA', val*25.4));

function guessval(fd, key, val)
if nargin<3
  val = 0;
  t = '0';
else
  t = '1';
end
keyval(fd, sprintf('%s_GUESS', key), val*25.4);
keyval(fd, sprintf('%s_GUESS_VALID', key), t);
keyval(fd, sprintf('%s_GUESS_ABS', key), t);