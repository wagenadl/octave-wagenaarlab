function cd_setarea(k)
global cd_data

cd_data{gcbf}.area = k;
gmi_plotimage(gcbf);
