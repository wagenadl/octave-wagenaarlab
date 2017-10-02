function [dat, tms] = mmframes(ifn, frms, filt, varargin)
% MMFRAMES - Grab frames from a movie NYI
%    dat = MMFRAMES(ifn) grabs all frames from any movie that MMREAD can
%    handle. Note: Output is CxXxYxN.
%    [dat, tms] = MMFRAMES(ifn) returns time stamps as well.
%    MMFRAMES(ifn, frms) loads only specified frames; [] for all frames.
%    MMFRAMES(ifn, frms, filt, extra) passes the data through the specified
%    filter function with given additional parameters.

if nargin<2
  frms=[];
end
if nargin<3
  filt=[];
end
trySeeking = ~isempty(frms);

currentdir = pwd;
cd(fileparts(which('FFGrab')));

FFGrab('build', ifn, '', double(0), double(1), double(trySeeking));

FFGrab('setMatlabCommand', '');

FFGrab('doCapture');
