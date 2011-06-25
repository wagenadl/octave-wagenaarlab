function plot8x8(data,aux)
% PLOT8X8(data) plots 8x8 graphs of data.
% data must be 61xN, with data(1,:) being labels, data(2:61,:) values
% for each of 60 electrode channels.
% PLOT8X8(data,aux) passes aux as a third arg to PLOT.

if (nargin<2)
  aux='';
end

for hw=0:59
  subplot(8,8,hw2cr(hw));
  plot(data(1,:),data(hw+2,:),aux);
  axis tight;
end
