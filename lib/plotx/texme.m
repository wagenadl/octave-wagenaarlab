function texme(ifn,ofn,withcode)
% TEXME - Creates a pdf file with all figures created by an m-file
%    TEXME(ifn,ofn) creates a pdf with all figures created by the named
%    file.
%    TEXME(ifn,ofn,1) copies the code from IFN into OFN.
%    TEXME(ifn,ofn,2) copies the code from IFN into OFN in two-column format.
%    TEXME(ifn) makes OFN be the same as IFN with ".m" replaced by ".pdf".
%    In any event, comment lines that start "%#" in IFN are treated specially:
%    If they are in a block that begins with "%## FIGURE n", they are
%    used as comments to a specific figure; otherwise, they are typeset
%    as regular text.

if nargin<2
  ofn='';
  withcode=0;
elseif nargin<3
  if ischar(ofn)
    withcode=0;
  else
    withcode=ofn;
    ofn='';
  end
end
mfn = which(ifn);
if isempty(mfn)
  error(['TEXME: Input file "' ifn '" not found']);
end
if nargin<2 | isempty(ofn)
  if endswith(ifn,'.m')
    ofn = [ifn(1:end-1) 'pdf'];
  else
    ofn = [ifn '.pdf'];
  end
end

fprintf(1,'TEXME: running "%s"\n  and creating "%s".\n',mfn,ofn);

close all
drawnow

if endswith(ifn,'.m')
  run(mfn);
else
  eval(ifn);
end

printall('/tmp/texme.eps');

cmd = sprintf('texme-core %s %i',mfn,withcode);
ff = sort(findobj(0,'type','figure'));
for f=ff(:)'
  set(f,'paperu','inch');
  p=get(f,'paperp');
  cmd = [cmd sprintf(' %i:%.2f:%.2f',f,p(3),p(4))];
end

s = unix(cmd);
if s
  error([ 'TEXME: failed to run "' cmd '".']);
end
unix(sprintf('mv /tmp/texme.pdf %s',ofn));
close all
fprintf(1,'Output is in "%s". I am starting evince for you.\n',ofn);
system(sprintf('evince %s&',ofn));

