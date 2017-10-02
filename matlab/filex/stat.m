function s = stat(fn)
% STAT   Unix stat
%    s = STAT(fn) retrieves stat(2) information.
%    Result is a structure with fields:
%
%      dev      ID of device containing file
%      ino      inode number
%      mode     protection
%      nlink    number of hard links
%      uid      user ID of owner
%      gid      group ID of owner
%      rdev     device ID (if special file)
%      size     total size, in bytes
%      blksize  blocksize for filesystem I/O
%      blocks   number of blocks allocated
%      atime    time of last access (in DATENUM form)
%      mtime    time of last modification (in DATENUM form)
%      ctime    time of last status change (in DATENUM form)
%
%    In addition, mode flags are expanded as perm.usr, perm.grp, perm.oth;
%    perm.sgid, perm.suid, and a set of type.xxx flags for file types.

if ~exist(fn,'file')
  s = [];
  return;
end

ar = stat_core(fn);

s.dev = ar(1);
s.ino = ar(2);
s.mode = uint32(ar(3));
s.nlink = ar(4);
s.uid = ar(5);
s.gid = ar(6);
s.rdev = ar(7);
s.size = ar(8);
s.blksize = ar(9);
s.blocks = ar(10);
d = datenum([1970 1 1 0 0 0]);
tms=double(ar(11:13)) - double(ar(14));
s.atime = tms(1)/86400+d;
s.mtime = tms(2)/86400+d;
s.ctime = tms(3)/86400+d;

s.perm.usr = bitshift(bitand(s.mode,uint32(7*8*8)),-6);
s.perm.grp = bitshift(bitand(s.mode,uint32(7*8)),-3);
s.perm.oth = bitand(s.mode,uint32(7));
s.perm.svtx = bitshift(bitand(s.mode,uint32(8*8*8)),-9);
s.perm.sgid = bitshift(bitand(s.mode,uint32(2*8*8*8)),-10);
s.perm.suid = bitshift(bitand(s.mode,uint32(4*8*8*8)),-11);
s.perm.type = bitshift(bitand(s.mode,uint32(15*8*8*8*8)),-12);

s.perm.usr_r = bitand(s.perm.usr,uint32(4))>0;
s.perm.usr_w = bitand(s.perm.usr,uint32(2))>0;
s.perm.usr_x = bitand(s.perm.usr,uint32(1))>0;

s.perm.grp_r = bitand(s.perm.grp,uint32(4))>0;
s.perm.grp_w = bitand(s.perm.grp,uint32(2))>0;
s.perm.grp_x = bitand(s.perm.grp,uint32(1))>0;

s.perm.oth_r = bitand(s.perm.oth,uint32(4))>0;
s.perm.oth_w = bitand(s.perm.oth,uint32(2))>0;
s.perm.oth_x = bitand(s.perm.oth,uint32(1))>0;

s.type.fifo = s.perm.type==1;
s.type.chr = s.perm.type==2;
s.type.dir = s.perm.type==4;
s.type.blk = s.perm.type==6;
s.type.reg = s.perm.type==8;
s.type.link = s.perm.type==10;
s.type.sock = s.perm.type==12;


