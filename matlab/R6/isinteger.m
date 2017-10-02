function yn = isinteger(obj)
% ISINTEGER - True for objects whose class names match 'int'
%   yn = ISINTEGER(obj) returns true if OBJ is an integer (e.g. uint8).
%   Note that in V.7, there is a builtin ISINTEGER with the same semantics.
c=class(obj);
yn = ~isempty(strfind(c,'int'));
