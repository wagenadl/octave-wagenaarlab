function str = mtc_denormalizecoords(str, res)

str.x = str.x .* res.sx + res.x0;
str.y = str.y .* res.sy + res.y0;
str.rx = str.rx .* res.sx;
str.ry = str.ry .* res.sy;
str.r = str.r .* sqrt((res.sx.^2 + res.sy.^2) / 2);