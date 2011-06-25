function mov=xcorslices(co,max) 
% mov=XCORSLICES(co,max) creates a movie of cross correlations
N=length(co{1}{1})/2;
for n=1:N
  n
  xcorslice(co,n,max);
  title(sprintf('Time bin %i',n));
  mov(n)=getframe(gcf);
end
