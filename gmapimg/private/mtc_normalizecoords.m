function [str, res] = mtc_normalizecoords(str, marklr)
% MTC_NORMALIZECOORDS 
if nargin<2
  marklr = 0;
end

w = str.r.^2;
w = w./sum(w);

res.x0 = sum(w .* str.x);
res.y0 = sum(w .* str.y);

str.x = str.x - res.x0;
str.y = str.y - res.y0;

res.sx = sqrt(sum(w .* str.x.^2));
res.sy = sqrt(sum(w .* str.y.^2));

str.x = str.x ./ res.sx;
str.y = str.y ./ res.sy;

if isfield(str, 'rx')
  str.rx = str.rx ./ res.sx;
  str.ry = str.ry ./ res.sy;
end

str.r = str.r ./ sqrt((res.sx.^2 + res.sy.^2) / 2); % Not exact

if isfield(str, 'id') && marklr
  ids = str.id;
  for r=1:length(str.id)
    idx = find(strcmp(str.id{r}, str.id));
    if length(idx)==2
      if str.x(r)>str.x(idx(idx~=r))
        ids{r} = [str.id{r} "_R"];
      else
        ids{r} = [str.id{r} "_L"];
      end
    end
  end
  str.id = ids;
end
