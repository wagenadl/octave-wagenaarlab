function img = ppmread(fn)
% PPMREAD - Read ppm images
%   img = PPMREAD(fn) reads a ppm file

fd = fopen(fn, 'r');
l1 = chomp(fgets(fd));
l2 = chomp(fgets(fd));
l3 = chomp(fgets(fd));

switch l1
  case 'P6'
    typ = '*uint16';
    C = 3;
  otherwise
    error 'For now, I am only dealing with 16 bits 3 color images'
end

dims = strsplit(l2, ' ');
X = atoi(dims{1});
Y = atoi(dims{2});

img = fread(fd, [C*X*Y], typ, 'ieee-be');
if length(img)~=C*X*Y
  error('Premature end of file');
end

img = reshape(img, [C X Y]);
img = permute(img, [3 2 1]);

bb = fread(fd, [1 inf], typ);
if ~isempty(bb)
  warning('Not at end of file');
end
