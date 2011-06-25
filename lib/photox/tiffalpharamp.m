function alp = tiffalpharamp(alp,rx)
% TIFFALPHARAMP - Create a ramp from an alphamap
%    alp = TIFFALPHARAMP(alp,rx) makes the edges of the alphamap ALP come
%    up linearly rather than stepwise. 
%    This works in the first dimension of the map.
%    Input may be on a 0-255 or 0-1 scale; output is always 0-1.
%    The ramp has length RX.

alp = double(alp);
mx=max(alp(:));
[Y X]=size(alp);

if mx>1
  alp=alp/255;
end

for x=1:X
  [i_on,i_of] = schmitt(alp(:,x),.001,.0005,2);
  for k=1:length(i_on)
    L=i_of(k)-i_on(k)-1;
    rmp=[0:1/rx:1]';
    if length(rmp)>L
      rmp=rmp(1:L);
    else
      L=length(rmp);
    end
    alp(i_on(k)+[1:L]-1,x) = alp(i_on(k)+[1:L]-1,x) .* rmp;
    alp(i_of(k)-[1:L],x) = alp(i_of(k)-[1:L],x) .* rmp;
  end
end
