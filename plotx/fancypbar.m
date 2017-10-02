function [hl,ht] = fancypbar(p,xx,y0, varargin)
% FANCYPBAR - Indicate significance by stars and a brace
%    FANCYPBAR(p,xx,y0) plots a bracket and stars over the data at
%    (XX,Y0). XX must be a two-element vector, Y0 a scalar.
%    A brace is only plotted if P<=.05. 
%    FANCYPBAR(p,xx,y0, 'under') places the bracket below rather than
%    above the data.
%    FANCYPBAR(p,xx,y0, dy), where DY is a three-element vector, specifies
%    how far away the bracket and the stars are from the data, in inches:
%    DY = [DIST HEIGHT SPACE] places the brace DIST inches away from Y0,
%    gives it a height of HEIGHT inches, and places the text SPACE away from
%    the horizontal.
%    FANCYPBAR(str,xx,y0) uses the text STR rather than some stars.
%    [lh,th] = FANCYPBAR(...) returns handles of the line and the text.

if ischar(p)
  str=p;
else
  str = pstars(p);
end
if isempty(str)
  lh=[]; th=[];
else
  sty='over';
  dy=[];
  if length(varargin)>=1
    if ischar(varargin{1})
      sty = varargin{1};
    else
      dy = varargin{1};
    end
  end
  if length(varargin)>=2
    if ischar(varargin{2})
      sty = varargin{2};
    else
      dy = varargin{2};
    end
  end    

  if isempty(dy)
    dy=.03;
  end
  if length(dy)<2
    dy=[dy dy];
  end
  if length(dy)<3
    dy=[dy(:)' dy(1)];
  end
  if strcmp(sty,'under')
    direc=-1;
  else
    direc=1;
  end
  hl = shiftedplot([xx(1) xx(1) xx(2) xx(2)],[0 0 0 0]+y0,...
      [0 0 0 0],direc*([0 dy(2) dy(2) 0]+dy(1)),'k');
  ht = shiftedtext(mean(xx),y0,0,direc*sum(dy),str,'horizontala','center');
  if direc>0
    if ischar(p)
      set(ht,'verticala','bottom'); % Really, if the string has no descenders,
	                            % 'baseline' would be better...
    else
      set(ht,'verticala','middle'); % For stars, because they are high up.
    end
  else
    set(ht,'verticala','top');
  end
end

if nargout<2
  clear ht
end
if nargout<1
  clear hl
end
