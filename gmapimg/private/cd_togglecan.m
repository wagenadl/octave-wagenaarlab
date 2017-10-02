function cd_togglecan(h,x)
global cd_data

cd_data{gcbf}.cvis = ~cd_data{gcbf}.cvis;
gmi_plotimage(gcbf);

ht = cd_data{gcbf}.hta;
if cd_data{gcbf}.cvis
  set(ht, 'visible', 'on');
else
  set(ht, 'visible', 'off');
end
