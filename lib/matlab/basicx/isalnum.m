function b=isalnum(s)
% ISALNUM - True if a character is a digit, a letter, or underscore
%   b = ISALNUM(s) returns a logical vector stating whether the characters 
%   in S are alphanumeric (incl. underscore).

b = isdigit(s) | isalpha(s) | s=='_';
