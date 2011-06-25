function t = fdate(fn)
s = stat(fn);
t = s.mtime;
