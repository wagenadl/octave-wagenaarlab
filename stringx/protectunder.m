function y = protectunder(x)
% PROTECTUNDER - Place backslashes before underscores in a string

y='';
L=length(x);
for l=1:L
  if x(l)=='_'
    y=[y '\_'];
  elseif x(l)=='\'
    y=[y '\\'];
  else
    y=[y x(l)];
  end
end
