function xy=fibacktrace(img,x,y)
% FIBACKTRACE - Backtracing incremental floodfill
%    xy = FIBACKTRACE(img, x, y), where IMG is the output of FLOODINC and (x,y)
%    specifies a start position, back traces to the minimum pixel value and
%    returns the trace.
xy = fibacktrace_core(uint32(img),y-1,x-1);
xy=double(xy);
xy=xy+1;
xy=flipud(xy)';
