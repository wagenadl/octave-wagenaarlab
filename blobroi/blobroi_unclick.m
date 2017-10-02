function blobroi_unclick(h,x)
% BLOBROI_UNCLICK - Mouse button release handler for blobroi
%   This disables the response to future mouse motion.
set(h,'windowbuttonmotionfcn',[]);
