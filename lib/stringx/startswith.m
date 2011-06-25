function yn = startswith(str,sub)
% STARTSWITH - Returns true if a string starts with a given substring
%    yn = STARTSWITH(str,sub) returns true if the beginning of STR equals SUB.

if length(str)<length(sub)
  yn=0;
elseif strcmp(str(1:length(sub)),sub)
  yn=1;
else
  yn=0;
end
