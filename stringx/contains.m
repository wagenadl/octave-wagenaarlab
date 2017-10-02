function yn = contains(str, sub)
% CONTAINS - Returns true if a string contains a given substring
%   yn = CONTAINS(str, sub) returns true if SUB occurs within STR

yn = ~isempty(strfind(str, sub));
