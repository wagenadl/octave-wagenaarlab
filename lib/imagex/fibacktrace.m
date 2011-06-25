function xy=fibacktrace(img,x,y)
xy = fibacktrace_core(uint32(img),y-1,x-1);
xy=double(xy);
xy=xy+1;
xy=flipud(xy)';
