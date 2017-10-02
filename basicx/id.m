function varargout = id(varargin)
% ID - The identity function
%   [x,y,z,...] = ID(a,b,c,...) returns its input arguments
%   without change, for any kind of argument.
%   This is very useful, e.g., for implementing a swap function:
%
%      [x,y] = ID(y,x).
% 
%   Another major use is to copy values to function arguments during
%   development.

varargout=varargin;

