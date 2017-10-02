function scatter60(spks)
% SCATTER60(spks) is as scatter1, but it plots all channels in a
% single graph, using colors to label columns and plot symbols for rows.
for hw=0:59
  cr=hw2crd(hw);
  r=mod(cr,10); 
  c=floor(cr/10);
  cols=[ 1 0 0; 1 .8 .0; 0 .4 0; 0 1 0; ...
	 0 0 1; .5 .6 1; .7 0 .7; 1 .3 1 ];
  syms='ox+*sdv^';
  idx=find(spks(:,2)==hw);
  a=plot(spks(idx,1),spks(idx,5),syms(c));
  set(a,'Color',cols(r,:));
  hold on
end
hold off
