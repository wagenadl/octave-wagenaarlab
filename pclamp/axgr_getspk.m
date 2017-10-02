function [y,ctxt] = axgr_getspk(axgr,thr,gwid,cwid)
% y = AXGR_GETSPK(axgr,thr,winwid,cwid) gets spikes from all channels
% of an axograph file. AXGR may be either a structure returned by an 
% axgr2m-created function, or the name of such a function.
% THR, GWID, CWID are passed straight to GCSPIKE.
% 
% Output is structure with members:
%
%   tms: times (in s) of spikes
%   chs: channels on which spikes happen
%   axgr: original AXGR structure.
%
% Defaults are:
%   THR: 10
%   GWID: 5
%   CWID: 25
%
% [tt,ctxt] = ... returns the contexts of each of the spikes as well.

if isstr(axgr)
  fprintf(1,'Loading information file...\n');
  eval([ 'axgr = ' axgr ';' ]);
end

if ~isstruct(axgr)
  error('First argument is not a structure');
end

if nargin<2 | isempty(thr)
  thr=10;
end 

if nargin<3 | isempty(gwid)
  gwid=5;
end

if nargin<4 | isempty(cwid)
  cwid=25;
end

N = axgr.columns-1;

y.axgr = axgr;

y.tms=[];
y.chs=[];

if nargout>=2
  ctxt=[];
end

for n=1:N
  fprintf(1,'Loading raw file %i...\n',n);
  vv = axgrload(axgr,n);
  fprintf(1,'Detecting spikes on channel %i...\n',n);
  if nargout>=2
    [tt,cc] = gcspike(vv,gwid,cwid);
    ctxt = cat(2,ctxt,cc);
  else
    tt = gcspike(vv,gwid,cwid);
  end

  K=length(tt);
  y.tms = [y.tms tt(:)'];
  y.chs = [y.chs zeros(1,K)+n];
end

y.tms = y.tms .* y.axgr.xinterval;
