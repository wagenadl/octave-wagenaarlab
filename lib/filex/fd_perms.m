function str = fd_perms(st_mode)
% FD_PERMS  Represent file permission flags as per ls(1)
%    str = FD_PERMS(st_mode), where ST_MODE is the mode field from STAT,
%    represents file permissions.
st_mode = uint32(st_mode);
tp='-';
if bitand(st_mode,2^15) & bitand(st_mode,2^14)
  tp='s'; % Socket
elseif bitand(st_mode,2^15) & bitand(st_mode,2^13)
  tp='l'; % Symlink
elseif bitand(st_mode,2^14) & bitand(st_mode,2^13)
  tp='b'; % Block
elseif bitand(st_mode,2^14)
  tp='d'; % Dir
elseif bitand(st_mode,2^13)
  tp='c'; % Char
elseif bitand(st_mode,2^12)
  tp='f'; % Fifo
end
ownperm = fd_oneperm(bitand(st_mode,7*2^6),2^6);
grpperm = fd_oneperm(bitand(st_mode,7*2^3),2^3);
othperm = fd_oneperm(bitand(st_mode,7),1);
str = [tp ownperm grpperm othperm];

function str = fd_oneperm(st_mode,mult)
str='---';
if bitand(st_mode,4*mult)
  str(1) = 'r';
end
if bitand(st_mode,2*mult)
  str(2) = 'w';
end
if bitand(st_mode,1*mult)
  str(3) = 'x';
end
