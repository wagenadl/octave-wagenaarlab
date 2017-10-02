function gmi_togglecan(f)
global cd_data

cd_data{f}.cvis = ~cd_data{f}.cvis;
gmi_plotimage(f);

ht = cd_data{f}.ht;
if cd_data{f}.cvis
  iset(ht, 'visible', 'on');
else
  iset(ht, 'visible', 'off');
end
