function plot8x8x2(data,aux1,aux2)
% PLOT8X8x2(data) plots 8x8 graphs of data.
% data must be 121xN, with data(1,:) being labels, 
% data([2 4 6 .. 120],:) values to be plot in red,
% data([3 5 7 .. 121],:) values to be plot in blue.
% PLOT8X8(data,aux) passes aux as a third arg to PLOT.

if (nargin<2)
  aux1='';
end
if (nargin<3)
  aux2='';
end

for hw=0:59
  subplot(8,8,hw2cr(hw));
  plot(data(1,:),data(hw*2+2,:)/10+5,aux1,data(1,:),data(hw*2+3,:),aux2);
  axis([-2 5 -0 10]);
end
