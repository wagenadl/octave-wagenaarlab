function gmi_localalign(f, area)
global cd_data
if nargin<2
  for a=2:5
    gmi_quickalign(f, a, 1);
  end
  gmi_plotimage(f);
else
  gmi_quickalign(f, area, 1);
end
