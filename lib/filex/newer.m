function ok=newer(fn1,fn2)
% NEWER - Compare file ages
%   NEWER(fn1,fn2) returns true if FN1 exists and is newer than FN2.

if ~exist(fn1,'file')
  ok = 0;
  return
end

if ~exist(fn2,'file')
  ok = 0;
  return
end

st1=stat(fn1);
st2=stat(fn2);

ok = st1.mtime > st2.mtime;
