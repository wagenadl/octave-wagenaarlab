function str = af_apply(xf, str)
z = ones(size(str.x));

x = xf(1,1) .* str.x + xf(1,2) .* str.y + xf(1,3) .* z;
y = xf(2,1) .* str.x + xf(2,2) .* str.y + xf(2,3) .* z;
z = xf(3,1) .* str.x + xf(3,2) .* str.y + xf(3,3) .* z;
str.x = x ./ z;
str.y = y ./ z;
