function xxx = unhist(xx,nn)
% UNHIST   Converse of HIST, generate data vector from histogram.
%    xxx = UNHIST(xx,nn) generates a vector composed of nn(1) copies
%    of xx(1), nn(2) copies of xx(2), etc.
%    (Note that, of course, UNHIST cannot recreate your original data
%    if you have summarized it through HIST.)

xx=real(xx(:));
nn=uint32(nn(:));
if length(xx)~=length(nn)
  error('Length of arguments must match.');
end

xxx = unhist_core(xx,nn);
