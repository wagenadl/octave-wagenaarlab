function gmi_buttonup(h,x)
f = igcbf;
global cd_data

printf('buttonup %g %g\n', h, x);

relpt = iget(h, 'currentpoint');
presspt = cd_data{f}.presspt;
if isempty(presspt)
  printf('release without press\n');
  return;
end
cd_data{f}.presspt = [];
prs.x = presspt(1);
prs.y = presspt(2);
rel.x = relpt(1);
rel.y = relpt(2);

if (prs.x-rel.x).^2 + (prs.y-rel.y).^2 < 5.^2
  % Minimally moved
  printf('click\n');
  [r,n] = min((cd_data{f}.act.x-prs.x).^2./cd_data{f}.act.rx.^2 ...
      + (cd_data{f}.act.y-prs.y).^2./cd_data{f}.act.ry.^2);
  if r<1
    if x==1
      if cd_data{f}.area>1
        if cd_data{f}.act.hasarea(n)
          cd_data{f}.act.hasarea(n) = 0;
        else
          cd_data{f}.act.hasarea(n) = 1;
          cd_data{f}.act.area(n) = cd_data{f}.area;
        end
        gmi_autoarea(f);
      end
    else
      cd_data{f}.act.id{n} = '';
      cd_data{f}.act.idx(n) = nan;
      cd_data{f}.act.hasidx(n) = 0;
      iset(cd_data{f}.hta(n), 'weight', 'normal', 'angle', 'italic');
      iset(cd_data{f}.hta(n), 'text', cd_shortid(cd_data{f}.act.id{n}));
    end
  else
    printf('(Click not on actual)\n');
  end
else
  % Actual drag
  [r,n] = min((cd_data{f}.act.x-rel.x).^2./cd_data{f}.act.rx.^2 ...
      + (cd_data{f}.act.y-rel.y).^2./cd_data{f}.act.ry.^2);
  [r1, m] = min((cd_data{f}.cres.x-prs.x).^2./cd_data{f}.can.rx.^2 ...
      + (cd_data{f}.cres.y-prs.y).^2./cd_data{f}.can.ry.^2);
  if r<1 && r1<1
    printf('(drag to %s)\n', cd_data{f}.can.id{m});
    area = cd_data{f}.can.area(m);
    cd_data{f}.act.id{n} = cd_data{f}.can.id{m};
    cd_data{f}.act.idx(n) = m;
    cd_data{f}.act.hasidx(n) = 1;
    cd_data{f}.act.hasarea(n) = 1;
    cd_data{f}.act.area(n) = area;
    iset(cd_data{f}.hta(n), 'weight', 'bold', 'angle', 'normal');
    if cd_data{f}.area~=area && cd_data{f}.area>1
      cd_data{f}.area = area;
    end
    gmi_autoarea(f);
    iset(cd_data{f}.hta(n), 'text', cd_shortid(cd_data{f}.act.id{n}));
  else
    printf('Drag to nowhere\n');
  end
  iset(cd_data{f}.hta(n), 'text', cd_shortid(cd_data{f}.act.id{n}));
end

