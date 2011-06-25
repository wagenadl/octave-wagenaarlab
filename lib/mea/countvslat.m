function countvslat(fn)
% COUNTVSLAT(fn) plots 8x8 graphs of count vs latency graphs from a
% given file, produced by countvslat.pl

cvl=load(fn,'-ascii');

latidx=[2:3:179];
cntidx=[3:3:180];

for hw=0:59
  subplot(8,8,hw2cr(hw));
  plot(cvl(:,latidx(hw+1)),cvl(:,cntidx(hw+1)),'r.','MarkerSize',6);
  v=axis;
  axis([0 .010 v(3) v(4)]);
end
