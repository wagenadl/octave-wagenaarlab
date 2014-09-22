function luvdemo

[xx, yy] = xxyy(300);

qfigure('/tmp/luvdemo1', 4, 4);
l=0;
for y=1:3
  for x=1:3
    l = l + 1;
    qsubplot((x-1)/3, (y-1)/3, 1/3, 1/3);
    luv = cat(3, 10*l + 0*xx, 100*yy, 2*pi*xx);
    qimage(colorconvert(luv, 'from', 'cielchuv', 'to', 'srgb', 'clip', nan));
    qshrink 1
  end
end

qfigure('/tmp/luvdemo2', 4, 4);
l=0;
for y=1:3
  for x=1:3
    l = l + 1;
    qsubplot((x-1)/3, (y-1)/3, 1/3, 1/3);
    luv = cat(3, 10*l + 0*xx, 100*yy, 2*pi*xx);
    xyz = colorconvert(luv, 'from', 'cielchuv', 'to', 'ciexyz', 'clip', 2);
    qimage(colorconvert(xyz, 'from', 'ciexyz', 'to', 'srgb', 'clip', 2));
    qshrink 1
  end
end

qfigure('/tmp/luvdemo3', 4, 4);
l=0;
for y=1:3
  for x=1:3
    l = l + 1;
    qsubplot((x-1)/3, (y-1)/3, 1/3, 1/3);
    luv = cat(3, 10*l + 0*xx, 2*yy, 2*pi*xx);
    qimage(colorconvert(luv, 'from', 'lshuv', 'to', 'srgb', 'clip', nan));
    qshrink 1
  end
end

qfigure('/tmp/luvdemo4', 4, 4);
l=0;
for y=1:3
  for x=1:3
    l = l + 1;
    qsubplot((x-1)/3, (y-1)/3, 1/3, 1/3);
    luv = cat(3, 10*l + 0*xx, 2*yy, 2*pi*xx);
    qimage(colorconvert(luv, 'from', 'lshuv', 'to', 'srgb', 'clip', 2));
    qshrink 1
  end
end

