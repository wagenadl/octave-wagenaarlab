function printto(ofn,opts)
% PRINTTO(ofn) prints the current figure to OFN.
% PRINTTO(ofn,opts) specifies further print options
%
% Device type is determined from extension.
%
% Example: PRINTTO('hello.png','-r200');

if nargin<2
  opts='';
end

dev = fn2dev(ofn);
if strcmp(dev,'png')
  opts=[ '-r300 ' opts];
end

args = strtoks(sprintf('-d%s %s %s',dev, opts, ofn)); 

% Following hack ensures that Matlab 6.5 prints the whole area.
a=axis; 
hold on; 
h=plot([a(1) a(2)],[a(3) a(4)], 'w.', 'markersize', .1);

% Following hack ensures that Octave produces pdfs and eps that match
% figure size rather than standard paper.
wh = get(gcf, 'papersize');
xywh = get(gcf, 'paperposition');
set(gcf, 'papersize', xywh(3:4));
set(gcf, 'paperposition', [0 0 xywh(3) xywh(4)]);

print(args{:});

set(gcf, 'papersize', wh);
set(gcf, 'paperposition', xywh);
delete(h);

lasterr('');
