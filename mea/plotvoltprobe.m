function [vv,pp]=plotvoltprobe(ifn,ofn,v0,dv,v1,xtick,wantmul)
if nargin<6 | isempty(xtick)
  xtick=[v0:200:v1];
end
if nargin<7
  wantmul=2;
end
[vv_,pp_]=voltprobe(ifn,wantmul,v0,dv,v1,xtick,[0:2:10]);
print('-depsc',ofn);

vv_(pp_(:,1)<0)=nan;

if nargout>=1
  vv=vv_;
end
if nargout>=2
  pp=pp_;
end

