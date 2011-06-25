function varargout = identity(varargin)
% IDENTITY - The identity function
%   [x,y,z,...] = IDENTITITY(a,b,c,...) returns its input arguments
%   without change, for any kind of argument.
%   This is very useful, e.g., for implementing a swap function:
%
%      [x,y] = IDENTITY(y,x).

varargout=varargin;

