function area = cd_ventralarea(can)
N = length(can.id);
area = zeros(N,1);
for n=1:N
  id = can.id{n};
  if endswith(id, 'R')
    lat = 2;
  else
    lat = 0;
  end
  num = atoi(can.id{n});
  if num>=250
    area(n) = 7;
  elseif num>=200
    area(n) = 6;
  elseif num>=100
    area(n) = 2 + lat;
  elseif num>=50
    area(n) = 3 + lat;
  elseif startswith(id, 'AP') || startswith(id, 'N') || startswith(id, 'T') ...
        || startswith(id, 'HE')
    area(n) = 2 + lat;
  elseif startswith(id, 'P') || startswith(id, 'HN') || startswith(id, 'Ley')
    area(n) = 3 + lat;
  elseif startswith(id, 'CV') || startswith(id, 'Rz') || startswith(id,'S') ...
        || startswith(id, 'E21')
    area(n) = 6;
  elseif startswith(id, 'AE')
    area(n) = 7;
  else
    error(sprintf('Classification of %s unknown', id));
  end
end
