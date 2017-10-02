function lchdemo

[xx, yy] = xxyy(300);

qfigure('/tmp/lchdemo1', 4, 4);
l=0;
for y=1:3
  for x=1:3
    l = l + 1;
    qsubplot((x-1)/3, (y-1)/3, 1/3, 1/3);
    lch = cat(3, 10*l + 0*xx, 100*yy, 2*pi*xx);
    qimage(colorconvert(lch, 'from', 'cielch', 'to', 'srgb', 'clip', nan));
    qshrink 1
  end
end

qfigure('/tmp/lchdemo2', 4, 4);
l=0;
for y=1:3
  for x=1:3
    l = l + 1;
    qsubplot((x-1)/3, (y-1)/3, 1/3, 1/3);
    lch = cat(3, 10*l + 0*xx, 100*yy, 2*pi*xx);
    qimage(colorconvert(lch, 'from', 'cielch', 'to', 'srgb', 'clip', 2));
    qshrink 1
  end
end

qfigure('/tmp/lchdemo3', 4, 4);
l=0;
for y=1:3
  for x=1:3
    l = l + 1;
    qsubplot((x-1)/3, (y-1)/3, 1/3, 1/3);
    lch = cat(3, 10*l + 0*xx, 100*yy, 2*pi*xx);
    rgb = colorconvert(lch, 'from', 'cielch', 'to', 'srgb', 'clip', nan);
    okc = sum(~isnan(rgb(:,:,1)));
    nokc = size(rgb, 1) - okc;
    for x_ = 1:length(okc)
      if nokc(x_) > 0
        rgb(okc(x_)+1:end, x_, :) = repmat(rgb(okc(x_), x_, :), [nokc(x_) 1 1]);
      end
    end
    qimage(rgb);
    qshrink 1
  end
end



qfigure('/tmp/lchdemo4', 4, 4);
l=0;
for y=1:3
  for x=1:3
    l = l + 1;
    qsubplot((x-1)/3, (y-1)/3, 1/3, 1/3);
    lch = cat(3, 100*yy, 10*l + 0*xx, 2*pi*xx);
    xyz = colorconvert(lch, 'from', 'cielch', 'to', 'ciexyz', 'clip', nan);
    rgb = colorconvert(xyz, 'from', 'ciexyz', 'to', 'srgb', 'clip', nan);
    qimage(rgb);
    qshrink 1
  end
end
