function gmi_pressimage(h,x)
f=gcbf;
global cd_data;

ax = get(f, 'currentaxes');
cd_data{f}.presspt = get(ax, 'currentpoint');
