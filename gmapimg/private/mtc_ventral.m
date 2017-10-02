function str = mtc_ventral(renorm)
str = ventral;
str.phi = str.phi * pi/180;
str.y = -str.y;
str = mtc_normalizecoords(str, 2);

if nargin>=1 && renorm
  N = length(str.id);
  for n=1:N
    if endswith(str.id{n}, 'L')
      n1 = find(strcmp([str.id{n}(1:end-1) 'R'], str.id));
      if length(n1==1)
        x = mean(abs(str.x([n n1])));
        y = mean(str.y([n n1]));
        r = mean(str.r([n n1]));
        rx = mean(str.rx([n n1]));
        ry = mean(str.ry([n n1]));
        str.x([n n1]) = [-1 1]*x;
        str.y([n n1]) = y;
        str.r([n n1]) = r;
        str.rx([n n1]) = rx;
        str.ry([n n1]) = ry;
      end
    end
  end
end


ff = fieldnames(str);
for f=1:length(ff)
  str.(ff{f}) = str.(ff{f})';
end
