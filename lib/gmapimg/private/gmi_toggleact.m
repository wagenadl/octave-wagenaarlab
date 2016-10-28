function gmi_toggleact(f)
global cd_data

cd_data{f}.avis = ~cd_data{f}.avis;
gmi_plotimage(f);

ht = cd_data{f}.hta;
if cd_data{f}.avis
  iset(ht, 'visible', 'on');
else
  iset(ht, 'visible', 'off');
end
