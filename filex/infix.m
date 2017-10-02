function ofn = infix(fn,str)
% fns = INFIX(fn,str) injects STR into FN.
% I.e., if FN is "dir/base.ext", FNS will be "dir/base-str.ext".

[dr,bs,ex] = splitname(fn);

ofn = sprintf('%s/%s-%s.%s',dr,bs,str,ex);
