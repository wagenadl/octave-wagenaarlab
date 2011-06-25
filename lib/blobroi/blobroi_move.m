function blobroi_move(h,x)
axes_h = getappdata(h,'blob_axes_h');
xy1 = get(axes_h,'currentpoint');
xy1 = xy1(1,1:2);
blobroi_adjust(h,xy1);
