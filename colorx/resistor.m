function rgb=resistor(extra)
% rgb = RESISTOR(extra)
if nargin==0 || isempty(extra)
  extra=0;
end
rgb = [0 0 0; .7 .1 .1; 1 .1 0; .9 .6 0; .8 .8 0; 0 .8 0; 0 0 1; .7 0 1; .5 .5 .5];
%        1       2      3       4      5      6      7      8        9
if extra>0
  rgb=[rgb(1:6,:); [0 1 1]; rgb(7:8,:); [ 1 .3 1]; rgb(9,:)];
end
if extra>1
  rgb=[rgb; [.45 .45 1]; [0 .6 0]];
end

