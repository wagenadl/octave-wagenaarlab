function colorpicker
% COLORPICKER adds a callback to all images in current figure that reports 
% on the value(s) of a pixel clicked by the user.
hh=get(gcf,'children');
for h = hh(:)'
  cc=get(h,'children');
  for c = cc(:)'
    if strcmp(get(c,'type'),'image')
      set(c,'buttondownfcn',@cp_doit);
    end
  end
end
return

function cp_doit(c,x_)
h=get(c,'parent');
xy=get(h,'currentpoint');
dat=get(c,'cdata');
[Y X C]=size(dat);
x=floor(xy(1,1)+.5);
y=floor(xy(1,2)+.5);
if x>0 & x<=X & y>0 & y<=Y
  fprintf(1,'(%3i,%3i): ',y,x);
  fprintf(1,'%6g ',dat(y,x,:));
  fprintf(1,'\n');
end
return
