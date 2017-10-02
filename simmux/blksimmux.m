function simmux(ifn,ofn,BLK)
% SIMMUX(infn,outfn,blkcnt) reads BLKCNT spike files named INFN.NNNN.spike,
% where NNN counts 1..BLKCNT, and runs the simmux burst detection on it.
% Output is written to a single file named OUTFN.mat, which may be further
% processed by SIMMUXSIM to remove the block structure. See SIMMUXSIM for
% more.

for blk=1:BLK
  fprintf(2,'Block: %i/%i\n',blk,BLK); 
  spk=loadspike_noc(sprintf('%s.%03i.spike',ifn,blk),2);
  tms=spk.time; 
  chs=spk.channel; 
  clear spk 
  bb{blk}=simplexburst(tms,chs,0.200,4,0.500,7,10);
  cc{blk}=multixburst(bb{blk});
  [cc{blk}.gonset cc{blk}.goffset] = gonsetx(cc{blk},bb{blk},tms);
  %  cc{blk}.comap = comapx(cc{blk},tms,chs);
  dd{blk} = disjoinxburst(cc{blk},bb{blk},tms,chs);
end
save([ ofn '.mat'],'bb','cc','dd');
