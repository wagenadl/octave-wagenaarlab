function gmi_unassign(f, area)
if nargin<2
  for a=2:5
    gmi_unassign(f,a);
  end
  return
end

global cd_data

iact = find(cd_data{f}.act.area==area & ~cd_data{f}.act.hasidx);
cd_data{f}.act.idx(iact) = 0;
for n=iact(:)'
  cd_data{f}.act.id{n} = '';
  iset(cd_data{f}.hta(n), 'text', '');
end
