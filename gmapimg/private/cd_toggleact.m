function cd_toggleact(h,x)
global cd_data

cd_data{gcbf}.avis = ~cd_data{gcbf}.avis;
gmi_plotimage(gcbf);

ht = cd_data{gcbf}.hta;
if cd_data{gcbf}.avis
  set(ht, 'visible', 'on');
else
  set(ht, 'visible', 'off');
end
