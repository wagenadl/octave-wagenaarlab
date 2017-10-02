function srci = srci_out(varargin)
% SRCI_OUT - Add information about outputs to a SRCI structure
%    srci = SRCI_OUT(ofn) creates a new SRCI structure with a single
%      line stating that the file OFN was created today.
%    srci = SRCI_OUT(ofn, mfn) additionally includes MFN as the name of
%      the containing function.
%    srci = SRCI_OUT(srci, ...) prepends the information to an existing
%      SRCI structure.
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
if nargin>=argi & ischar(varargin{argi}) & varargin{argi}(end)==sprintf('\n')
  srci = varargin{argi};
  argi = argi+1;
end

ofn='';
mfn='';
while nargin>=argi
  if ischar(varargin{argi})
    if endswith(varargin{argi},'.m')
      mfn = varargin{argi};
    else
      ofn = varargin{argi};
    end
    argi = argi+1;
  else
    error('srci_out: incorrect arguments');
  end
end

srcibits = splitstring(srci,sprintf('\n'),1);
newbits={};
if ~isempty(ofn)
  newbits{end+1} = [ 'File: ' ofn ];
end
newbits{end+1} = [ 'Created: ' date ];
if ~isempty(ofn)
  newbits{end+1} = [ 'Produced by: ' mfn ];
end
[c,a] = system('hostname');
if c==0 & ~isempty(a)
  if a(end)<32
    a=a(1:end-1);
  end
  newbits{end+1} = [ 'Running on: ' a ];
end
newbits{end+1} = [ 'In directory: ' pwd];
newbits{end+1} = [ 'From sources:'];
srci = joinstring(newbits,sprintf('\n'));
srci(end+1) = sprintf('\n');
srci = [srci joinstring(srcibits,sprintf('\n'))];
srci(end+1) = sprintf('\n');
