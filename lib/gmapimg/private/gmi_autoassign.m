function gmi_autoassign(f, area)
global cd_data
if nargin<2
  A = max(cd_data{f}.can.area);
  for a=2:A
    gmi_autoassign(f, a);
  end
  return
end

ifix = find(cd_data{f}.act.area==area & cd_data{f}.act.hasidx);
usedcans = cd_data{f}.act.idx(ifix);
N = length(cd_data{f}.can.x);
avail = ~cd_data{f}.deletedcan;
avail(usedcans) = 0;
ican = find(cd_data{f}.can.area==area & avail);
can = subset(cd_data{f}.cres, ican);

idyn = find(cd_data{f}.act.area==area & ~cd_data{f}.act.hasidx);
act = cd_data{f}.act;
act.x = cd_data{f}.act.x;
act.y = cd_data{f}.act.y;
act = subset(act, idyn);

[idx, revidx, merit] = matchup3(act, can);

for n=1:length(idyn)
  k = idyn(n);
  if revidx(n)>0
    m = ican(revidx(n));
    cd_data{f}.act.idx(k) = m;
    id = cd_data{f}.can.id{m};
  else
    cd_data{f}.act.idx(k) = nan;
    id = '';
  end
  cd_data{f}.act.id{k} = id;
  iset(cd_data{f}.hta(k), 'text', cd_shortid(id));
end
