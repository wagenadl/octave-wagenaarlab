function gmi_unassign(f, area)

global cd_data

if nargin<2
  A = max(cd_data{f}.can.area);
  for a=2:A
    gmi_unassign(f,a);
  end
  return
end

iact = find(cd_data{f}.act.area==area & ~cd_data{f}.act.hasidx);
cd_data{f}.act.idx(iact) = nan;
for n=iact(:)'
  cd_data{f}.act.id{n} = '';
  iset(cd_data{f}.hta(n), 'text', '');
end
