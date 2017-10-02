function gmi_setarea(f, k)
global cd_data

cd_data{f}.area = k;
gmi_plotimage(f);
