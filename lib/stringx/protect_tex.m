function y = protect_tex(x)
% str = PROTECT_TEX(str) protect '_', '\', '^' in strings.

idx = find(x=='_' | x=='\' | x=='^');
idx=[0; idx(:); length(x)+1]; N = length(idx)-2;

y=[];
for n=1:N+1
  y=[y x(idx(n)+1:idx(n+1)-1)];
  if idx(n+1)<=length(x)
    y=[y '\' x(idx(n+1))];
  end
end
