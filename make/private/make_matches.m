function mtch = make_matches(x, pat)
% MAKE_MATCHES - Check if a target matches a pattern
%    mtch = MAKE_MATCHES(x, pat). PAT must contain precisely one '%' wildcard.
%    If the string X matches PAT, then MAKE_MATCHES will return the portion
%    of X that matches the wildcard. Otherwise, it returns [].

idx = find(pat == '%');
if length(idx)~=1
  mtch = '';
else
  pre = pat(1:idx-1);
  post = pat(idx+1:end);
  if startswith(x, pre) & endswith(x, post)
    mtch = x(length(pre)+1:end-length(post));
  else
    mtch = '';
  end
end

  