function img = pattern(pat,fg,bg,siz)
% img = PATTERN(pat,fg,bg,siz) creates a hash image of SIZxSIZ pixels.
% PAT is a pattern number:
% 0 - no pattern, just bg
% 1 - //
% 2 - \\
% 3 - ::
% 4 - +
% 5 - #
% If pattern is negative, fg and bg are reversed

if length(bg)==1
  res=resistor;
  bg=res(bg);
end
if length(fg)==1
  res=resistor;
  fg=res(fg);
end

bg = reshape(bg,[1 1 3]);
fg = reshape(fg,[1 1 3]);

if pat<0
  x=bg; bg=fg; fg=x; pat=-pat;
end

img = repmat(bg,[siz,siz,1]);

if pat==0
  ;
elseif pat==1
  for x0=floor(siz*.23):ceil(siz*.27)
    img=drawdiag(img,x0,1,fg);
  end
  for x0=floor(siz*.73):ceil(siz*.77)
    img=drawdiag(img,x0,1,fg);
  end
elseif pat==2
  for x0=floor(siz*.23):ceil(siz*.27)
    img=drawdiag(img,x0,-1,fg);
  end
  for x0=floor(siz*.73):ceil(siz*.77)
    img=drawdiag(img,x0,-1,fg);
  end
elseif pat==3
  img=drawcirc(img,siz*.25,siz*.25,siz*.03,siz*.1,fg);
  img=drawcirc(img,siz*.75,siz*.25,siz*.03,siz*.1,fg);
  img=drawcirc(img,siz*.25,siz*.75,siz*.03,siz*.1,fg);
  img=drawcirc(img,siz*.75,siz*.75,siz*.03,siz*.1,fg);
elseif pat==4
  for x0=floor(siz*.48):ceil(siz*.52)
    img=drawhori(img,x0,fg);
  end
  for x0=floor(siz*.48):ceil(siz*.52)
    img=drawvert(img,x0,fg);
  end  
elseif pat==5
  for x0=floor(siz*.23):ceil(siz*.27)
    img=drawhori(img,x0,fg);
  end
  for x0=floor(siz*.73):ceil(siz*.77)
    img=drawhori(img,x0,fg);
  end
  for x0=floor(siz*.23):ceil(siz*.27)
    img=drawvert(img,x0,fg);
  end
  for x0=floor(siz*.73):ceil(siz*.77)
    img=drawvert(img,x0,fg);
  end
else
  error(sprintf('Undefined pattern #%i',pat));
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function img=drawdiag(img,x0,dy,fg)
[X Y Z]=size(img);
for y=1:Y
  x=mod(x0+dy*y-1,X)+1;
  img(x,y,:)=fg;
end
return

function img=drawcirc(img,x0,y0,dr0,dr1,fg)
[X Y Z]=size(img);
xx=repmat([1:X]',[1 Y]);
yy=repmat([1:Y],[X 1]);
rr=(xx-x0).^2+(yy-y0).^2;
inside = repmat(rr>=dr0.^2 & rr<=dr1.^2,[1 1 3]);
img = img.*(1-inside) + repmat(fg,[X,Y,1]).*inside;
return

function img=drawhori(img,x0,fg)
[X Y Z]=size(img);
for y=1:Y
  img(x0,y,:)=fg;
end
return

function img=drawvert(img,x0,fg)
[X Y Z]=size(img);
for y=1:Y
  img(y,x0,:)=fg;
end
return
