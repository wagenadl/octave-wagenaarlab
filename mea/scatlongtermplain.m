function scatlongtermplain(bytrial,splittimes,cr,tmin_ms,tmax_ms,clickfn)
% SCATLONGTERMPLAIN(bytrial,splittimes,cr,tmin_ms,tmax_ms) plots a part of the
% scatterplot of spikes in FILES. 
% BYTRIAL must be a matrix loaded from output of meabench:bytrial.
% SPLITTIMES must be the filename of a .splittimes file, containing
% starting probe numbers (counting from 0), file lengths, original
% filenames and comments for the source files.
% CR must be an array of column-row indices. One plot is produced for
% each. [NYI: only the first item is used]
% TMIN_MS, TMAX_MS limit the horizontal scale of the graph.


hw=cr12hw(cr(1));
tmin_s=tmin_ms/1000;
tmax_s=tmax_ms/1000;

[i_start,i_length,fn,lbl] = textread(splittimes,'%n %n %q %q');

idx=find(bytrial(:,2)==hw);
spks=bytrial(idx,[1 5 6]);
idx2=find(spks(:,1) >= tmin_s & spks(:,1) <= tmax_s);
spks=spks(idx2,:);
plot(spks(:,1)*1000,spks(:,2),'.');

for i=1:length(i_start);
  l=line([tmin_ms tmax_ms], [i_start(i) i_start(i)]);
  set(l,'Color','green');
  if (length(lbl{i}) > 0)
    t=text(tmin_ms, i_start(i),[lbl{i} '   ']);
    set(t,'HorizontalAlignment','right');
  end
end

if nargin==6
  arg=[spks(:,1)*1000 spks(:,2) spks(:,3)]';
  whos arg;
  clickspikes(clickfn,arg);
end
