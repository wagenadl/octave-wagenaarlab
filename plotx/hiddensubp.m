function hiddensubp(R,C,r,c)
% HIDDENSUBP(R,C,r,c) - i.e. (Y,X,y,x), like subplot

hiddenaxes((c-1)/C,(R-r)/R,1/C,1/R);
