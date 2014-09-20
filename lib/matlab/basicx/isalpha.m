function b=isalpha(s)
% ISALPHA - True if a character is alphabetic
%    b = ISALPHA(s) returns a logical vector stating whether the characters 
%   in S are letters.

b = (s>='A' & s<='Z') | (s>='a' & s<='z');
