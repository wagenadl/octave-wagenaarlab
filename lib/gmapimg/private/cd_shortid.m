function id = cd_shortid(id)
if endswith(id, '_L') || endswith(id, '_R')
  id = id(1:end-2);
end
