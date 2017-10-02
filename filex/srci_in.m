function srci = srci_in(varargin)
% SRCI_IN - Add information about inputs to a SRCI structure
%    srci = SRCI_IN(ifn) creates a new SRCI structure with a single
%      line stating that the file IFN was used in the current function.
%    srci = SRCI_IN(ifn, s) additionally copies SRCI information from 
%      the structure S, which should be the entire contents of IFN, 
%      as per: s = load(ifn);
%    srci = SRCI_IN(s) only copies information from the structure S. This
%      could cause confusion if S does not contain a SRCI field.
%    srci = SRCI_IN(srci,...) adds to an existing structure.
%
%    SRCI data looks like this:
%      File: myfile.mat
%      Created: Nov 23, 2009
%      Produced by: mymaker.m
%      Running on: leech.caltech.edu
%      In directory: /home/me/myplace
%      From sources:
%        File: somesource.mat
%        Created: ...

srci = '';
argi = 1;
if nargin>=argi & ischar(varargin{argi}) & varargin{argi}(end)=='\n'
  src = varargin{argi};
  argi = argi+1;
end

if nargin>=argi
  if ischar(varargin{argi})
    ifn = varargin{argi};
    s = '';
  else
    ifn = '';
    s = varargin{argi};
  end
  argi = argi+1;
end

if nargin>=argi & ~isstruct(s) & isstruct(varargin{argi})
  s = varargin{argi};
  argi = argi+1;
end

if nargin>=argi 
  error('srci_in: incorrect arguments');
end

srcibits = splitstring(srci,sprintf('\n'),1);
if isstruct(s) & isfield(s,'srci')
  newbits = splitstring(s.srci,sprintf('\n'),1);
else
  newbits={};
end
if ~isempty(ifn)
  have=0;
  for k=1:length(newbits)
    if startswith(newbits{k},'File:')
      newbits{k} = [newbits{k} ' (' ifn ')'];
      have=1;
      break;
    end
  end
  if ~have
    newbits{end+1}='';
    for k=length(newbits):-1:2
      newbits{k} = newbits{k-1};
    end
    newbits{1} = sprintf('File: %s',ifn);
  end
end
srcibits{end+1}='  ';
for k=1:length(newbits)
  srcibits{end+1} = [ '  ' newbits{k}];
end
srci = joinstring(srcibits,sprintf('\n'));
srci(end+1)=sprintf('\n');
