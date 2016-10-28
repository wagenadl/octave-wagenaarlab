function gmi_unalign(f, area)
global cd_data
if nargin<2
  A = max(cd_data{f}.can.area);
  for a=2:A
    gmi_unalign(f, a)
  end
  gmi_plotimage(f);
  return
end
  
idx = find(cd_data{f}.can.area==area);

cres.x = cd_data{f}.can.x(idx);
cres.y = cd_data{f}.can.y(idx);

cd_data{f}.cres.x(idx) = cres.x;
cd_data{f}.cres.y(idx) = cres.y;

gmi_plotimage(f);
for n = 1:length(idx)
  iset(cd_data{f}.ht(idx(n)), 'pos', [cres.x(n) cres.y(n)]);
end
