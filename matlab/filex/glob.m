function fns = glob(pat)
% GLOB - Perform shell expansion
%    fns = GLOB(pat) returns a cell array of file names matching PAT.

if nargin~=1 | ~ischar(pat)
  error('GLOB must be given a string as input');
end

fns = glob_core(pat);
