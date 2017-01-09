function gmi_plotcanact(f)

global cd_data


%% Plot canonicals
N = length(cd_data{f}.can.id);
ht = zeros(N,1);
for n=1:N
  ht(n) = itext(cd_data{f}.cres.x(n), cd_data{f}.cres.y(n), ...
		cd_shortid(cd_data{f}.can.id{n}));
end
cd_data{f}.ht = ht;
iset(ht, 'halign', 'center', 'valign', 'middle');
iset(ht(find(cd_data{f}.deletedcan)), 'color', [.5 .5 1]);

%% Plot actuals
N = length(cd_data{f}.act.r);
hta = zeros(N,1);
for n=1:N
  hta(n) = itext(cd_data{f}.act.x(n), cd_data{f}.act.y(n), ...
		 cd_shortid(cd_data{f}.act.id{n}));
  if cd_data{f}.act.hasidx(n)
    iset(hta(n), 'weight', 'bold');
  else
    iset(hta(n), 'angle', 'italic');    
  end
end
cd_data{f}.hta = hta;

iset(hta, 'halign', 'center', ...
    'valign', 'middle', ...
    'color', [1 0 0]);
  
