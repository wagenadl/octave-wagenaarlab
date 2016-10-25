function gmi_autoarea(f)
global cd_data

fixidx = find(cd_data{f}.act.hasarea);
xfix = cd_data{f}.act.x(fixidx);
yfix = cd_data{f}.act.y(fixidx);

autoidx = find(~cd_data{f}.act.hasarea);
for n = autoidx(:)'
  dx = cd_data{f}.act.x(n) - xfix;
  dy = cd_data{f}.act.y(n) - yfix;
  [~, k] = min(dx.^2 + dy.^2);
  cd_data{f}.act.area(n) = cd_data{f}.act.area(fixidx(k));
end

gmi_plotimage(f);

