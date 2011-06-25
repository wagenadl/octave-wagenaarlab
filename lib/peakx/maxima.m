function idx = maxima(x,frc)
% MAXIMA - Find positions of maxima in a vector
%    idx = MAXIMA(x) returns the positions of the maxima in the vector X.
%    If a maximum is more than one sample wide, the first sample's index
%    is returned.
%    idx = MAXIMA(x,p) drops secondary maxima not separated by dips of 
%    less than p*(the nearest peak).

x = real(double(x(:)));
if nargin<2
  frc=1;
end
frc = double(frc);

if length(x)<2
  idx=[];
else
  idx = maxima_core(x,frc);
end

