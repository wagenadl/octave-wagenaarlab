function im1 = dilerode(im0, op)
% DILERODE - Dilation and erosion operations
%   im1 = DILERODE(im0, op) performs a dilation or erosion operation
%   Possible operations are:
%     'erode4': erode with a 4-neighborhood.
%     'erode8': erode with an 8-neighborhood.
%     'dilate4': dilate with a 4-neighborhood.
%     'dilate8': dilate with an 8-neighborhood.
%     'edge4': find edges by erosion with a 4-neighborhood.
%     'edge8': find edges by erosion with an 8-neighborhood.
%     'thin': retreat from edges using a 4-neighborhood but do not
%             disconnect regions or shrink objects to nothing. Here,
%             connectedness is based on an 8-neighborhood, and so are
%             edges. (But the erosion is done in 4-neighborhood.)
%     'skel': repeatedly 'thin' until a skeleton is left over
%   Output is always a binary image with zeros and ones.
%   The edge of the image is copied from the source and not processed.

OP_ERODE4 = 1;
OP_ERODE8 = 2;
OP_DILATE4 = 3;
OP_DILATE8 = 4;
OP_EDGE4 = 5;
OP_EDGE8 = 6;
OP_THIN = 7;
OP_SKEL = 8;

isDouble = isa(im0,'double');

im0=uint8(im0);

switch lower(op)
  case 'erode4'
    im1 = dilerode_core(im0, OP_ERODE4);
  case 'erode8'
    im1 = dilerode_core(im0, OP_ERODE8);
  case 'dilate4'
    im1 = dilerode_core(im0, OP_DILATE4);
  case 'dilate8'
    im1 = dilerode_core(im0, OP_DILATE8);
  case 'edge4'
    im1 = dilerode_core(im0, OP_EDGE4);
  case 'edge8'
    im1 = dilerode_core(im0, OP_EDGE8);
  case 'opening4'
    im1 = dilerode_core(dilerode_core(im0,OP_ERODE4),OP_DILATE4);
  case 'opening8'
    im1 = dilerode_core(dilerode_core(im0,OP_ERODE8),OP_DILATE8);
  case 'closing4'
    im1 = dilerode_core(dilerode_core(im0,OP_DILATE4),OP_ERODE4);
  case 'closing8'
    im1 = dilerode_core(dilerode_core(im0,OP_DILATE8),OP_ERODE8);
  case 'thin'
    im1 = dilerode_core(im0, OP_THIN);
  case 'skel'
    im1 = dilerode_core(im0, OP_SKEL);
  otherwise
    error 'dilerode: unknown operation'
end
if isDouble
  im1=double(im1);
end
