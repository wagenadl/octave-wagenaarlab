function plotdblctxt(dat, first, last)
  subplot(2,1,1);
  plot(dat.context(:,first:last));
  subplot(2,1,2);
  plot(dat.postflt(:,first:last));
return
