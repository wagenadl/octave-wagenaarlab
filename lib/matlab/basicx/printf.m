function printf(fmt,varargin)
% PRINTF  Write formatted data to stdout.
%    PRINTF(fmt,...) is like FPRINTF(1,fmt,...). 
fprintf(1,fmt,varargin{:});
