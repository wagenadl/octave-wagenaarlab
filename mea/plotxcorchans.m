function plotxcorchans(cor,nb,dt,crs)
% PLOTXCORCHANS(cor,nb,dt,crs) plots crosscorrels of crs vs all
% others. crs must be 4x1.
% cur must be loaded by loadcor, or be one element of a cell vector
% loaded by loadmanyxcor.

ra=nb-.5;

for c=1:4
  subplot(2,2,c);
  hw=cr12hw(crs(c));
  now=zeros(88-11+1,nb*2);
  Mx=0;
  mx=0;
  for hwd=0:59
    now(hw2crd(hwd)-10,:) = cor{hw+1}{hwd+1}';
    if hwd ~= hw
      Mm = max(now(hw2crd(hwd)-10,:));
      Mx = max([Mm Mx]);
      mm = min(now(hw2crd(hwd)-10,:));
      mx = min([mm mx]);
    end
  end
  for cr=11:88
    id=cr-10;
    idx = find(now(id,:) > Mx);
    now(id,idx) = Mx;
    idx = find(now(id,:) < mx);
    now(id,idx) = mx;
  end
%  now = now ./ max(max(now));
  pcolor([-ra:ra]*dt,[11:88],now);
  colormap(hot);
  colorbar;
  shading flat
  title(sprintf('Normalized counts CR %i-all',crs(c)));
  xlabel('ISI (ms)');
  ylabel('CR channel');
end
