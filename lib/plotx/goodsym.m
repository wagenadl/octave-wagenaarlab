function h = goodsym(xx,yy,symb,xr,yr,fg,bg)
% h = GOODSYM(xx,yy,symb,xr,yr,edge_col,face_col) plots the data (XX,YY) onto 
% the current plot using nice symbols.
% SYMB must be one of 'o' 's','d', '<', '>', '^', 'v'.
% XR and YR are the symbol sizes in x- and y-direction (in axes coords).
% Optional EDGE_COL, FACE_COL define edge and face colors. Defaults: Black.

if nargin<6
  fg=[0 0 0];
end
if nargin<7
  bg=fg;
end

if symb=='o'
  h = circles(xx,yy,xr,yr);
elseif symb=='s'
  h = squares(xx,yy,xr,yr);
elseif symb=='d'
  h = diamonds(xx,yy,xr,yr);
elseif symb=='<'
  h = lefttriangles(xx,yy,xr,yr);
elseif symb=='>'
  h = righttriangles(xx,yy,xr,yr);
elseif symb=='^'
  h = uptriangles(xx,yy,xr,yr);
elseif symb=='v'
  h = downtriangles(xx,yy,xr,yr);
end

set(h,'facec',bg);
set(h,'edgec',fg);

if nargout<1
  clear h
end
