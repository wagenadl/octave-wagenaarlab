function str = chomp(str)
% CHOMP - Removes newlines from end of string
%   str = CHOMP(str) removes any newlines from the end of the string STR

while endswith(str, "\n") || endswith(str, "\r")
  str = str(1:end-1);
end
