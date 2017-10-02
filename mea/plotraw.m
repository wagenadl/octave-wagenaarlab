function plotraw(dat)
n = length(dat);
k = floor(n/25);
dat = reshape(dat(:,1:k*25),[64 25 k]);
dat = squeeze(mean(dat, 2));
t=[1:k]/1000;

for c=1:64
  plot(t,(dat(c,:)-2048)/100 + c);
  hold on;
end

hold off;