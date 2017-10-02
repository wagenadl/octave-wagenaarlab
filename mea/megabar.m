function megabar(x,col);
K=length(x);
clf
for k=1:K
  b=bar(k,x(k));
  set(b,'facecolor',col{k});
  hold on
end
