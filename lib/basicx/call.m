function varargout = call(foo,varargin)
% CALL - Call a function in a different path
%   y = CALL(filename,args) temporarily enters the directory containing
%   FILENAME, and calls FILENAME as a function.

[d,b,e] = splitname(foo);
d0 = cd;
cd(d);
switch nargout
  case 0
    feval(b,varargin{:})
    varargout={};
  case 1
    v0 = feval(b,varargin{:});
    varargout={v0};
  case 2
    [v0,v1] = feval(b,varargin{:});
    varargout={v0,v1};
  case 3
    [v0,v1,v2] = feval(b,varargin{:});
    varargout={v0,v1,v2};
  case 4
    [v0,v1,v2,v3] = feval(b,varargin{:});
    varargout={v0,v1,v2,v3};
  case 5
    [v0,v1,v2,v3,v4] = feval(b,varargin{:});
    varargout={v0,v1,v2,v3,v4};
  otherwise
    error('CALL is only defined for <=5 output arguments.');
end
cd(d0);
