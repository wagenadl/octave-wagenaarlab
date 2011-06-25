function ax=axes8x8(xywd,mrg)
if nargin<1 | isempty(xywd)
  xywd=[0 0 1 1];
end

if nargin<2 | isempty(mrg)
  mrg=0;
end

ax=zeros(1,60);
for c=1:8
  for r=1:8
    hw=cr2hw(c,r);
    if hw>=0 & hw<60
      ax(hw+1) = axes('position',[(c-1)/8*xywd(3)+xywd(1),(8-r)/8*xywd(4)+xywd(2),...
	    xywd(3)/8-mrg,xywd(4)/8-mrg]);
    end
  end
end

