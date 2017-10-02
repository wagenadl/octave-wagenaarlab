function asize
% ASIZE  Print information about current axis limits
a=axis;
fprintf(1,'X-Axis: %7.3g (%7.3g - %7.3g)\n',a(2)-a(1),a(1),a(2));
fprintf(2,'Y-Axis: %7.3g (%7.3g - %7.3g)\n',a(4)-a(3),a(3),a(4));
