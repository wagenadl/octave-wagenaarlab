function xcorslice(co,bin,max)
% XCORSLICE(co,bin,max) plots a slice from a set of cross correllograms.
% co must be obtained from co=loadcor(fn).
% bin is a bin number (only half the bins in co are useful, since -ve
% bins are duplicated by loadcor for convenience).

vals = zeros(90,90);
realbin = bin + length(co{1}{1})/2;
for hw0=0:63
  for hw1=0:63
    v=co{hw0+1}{hw1+1}(realbin);
    if v>max
      v=max;
    end
    vals(hw2crd(hw0),hw2crd(hw1)) = v;
  end
end
vals(11,11)=max; vals(88,11)=0;
%pcolor(log(vals+1));
pcolor(vals);
axis([11 88 11 88]);
cc=[0:.02:1];
rr=2*cc+.5; rr(1)=0; rr(rr>1)=1;
gg=cc*1.3; gg(gg>1)=1;
bb=2*cc-1; bb(bb<0)=0;
%gg=1-2*cc; gg(gg<0)=0; gg=gg.^1.5;
%bb=0*cc; bb(1)=1;
%rr=2-2*cc; rr(rr>1)=1; rr=(rr+rr.^1.5)/2;
cc=[rr' gg' bb'];
cc(1,:)=[0 0 0 ];
%cc(1,:)=[1 1 1 ];
colormap(cc);
colorbar;

