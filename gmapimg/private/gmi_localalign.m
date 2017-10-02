function gmi_localalign(f, area)
global cd_data
if nargin<2
  A = max(cd_data{f}.can.area);
  for a=2:A
    gmi_quickalign(f, a, 1);
  end
  gmi_plotimage(f);
else
  gmi_quickalign(f, area, 1);
end
