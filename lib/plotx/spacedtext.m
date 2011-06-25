function h = spacedtext(x,y,dx,dy,hh,txt,varargin)
% SPACEDTEXT - Place a strings spaced relative to other strings
%    SPACEDTEXT(x,y,dx,dy,hh,txt) is like SHIFTEDTEXT, but if DX is
%    non-zero, X is ignored, and the extent of the bounding box of the
%    strings referenced by HH is used instead. Same for DY and Y.

bbox=[inf inf -inf -inf]; % x0 y0 x1 y1, in data coord
N=length(hh);
for n=1:N
  uni = get(hh(n),'units');
  set(hh(n),'units','data');
  xywh = get(hh(n),'extent');
  set(hh(n),'units',uni);
  bbox(1) = min(bbox(1),xywh(1));
  bbox(2) = min(bbox(2),xywh(2));
  bbox(3) = max(bbox(3),xywh(1)+xywh(3));
  bbox(4) = max(bbox(4),xywh(1)+xywh(4));
end

[xi,yi] = oneinch;

if dx>0
  x=bbox(3);
elseif dx<0
  x=bbox(1);
end
if dy>0
  y=bbox(4);
elseif dy<0
  y=bbox(2);
end

h = text(x+dx*xi, y+dy*yi, txt, varargin{:});
setappdata(h,'spacedtext_data',[x y dx dy hh(:)']);

if nargout<1
  clear h;
end
