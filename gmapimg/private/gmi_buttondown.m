function gmi_buttondown(h,x)
f = igcbf();
global cd_data;
cd_data{f}.presspt = iget(h, 'currentpoint');
printf('buttondown %g %g (%g %g)\n', f, h, ...
    cd_data{f}.presspt(1), cd_data{f}.presspt(2));
    