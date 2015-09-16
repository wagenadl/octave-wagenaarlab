function mosaicplot(xx, xlbl, ylbl)

[R C] = size(xx);
colsum = sum(xx);
rowsum = sum(xx, 2);

colfrac = colsum./sum(colsum);
celfrac = xx./repmat(colsum, R, 1);

cc = djet(R);

rght = cumsum(colfrac);
lft = [0 rght(1:end-1)];
wid = colfrac;
hei = celfrac;
top = cumsum(celfrac);
bot = [zeros(1,C); top(1:end-1,:)];


qpen w 2
for c=1:C
  for r=1:R
    qbrush(cc(r,:));
    qrectangle([lft(c) bot(r,c) wid(c) hei(r,c)]);
  end
end

qpen k 0
qxaxis(0, [0:.2:1], 'Relative frequency');
qyaxis(0, [0:.2:1], 'Relative frequency');
qalign center bottom
for c=1:C
  qat(lft(c)+wid(c)/2, 1);
  qtext(0, -5, xlbl{c});
end
qalign middle left
for r=1:R
  qat(1, bot(r,c)+hei(r,c)/2);
  qtext(5, 0, ylbl{r});
end
qshrink
