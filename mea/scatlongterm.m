function scatlongterm(files,startends,cr,tmin_ms,tmax_ms)
% SCATLONGTERM(files,startends,cr,tmin_ms,tmax_ms) plots a part of the
% scatterplot of spikes in FILES. 
% FILES must be a cell array of filenames, produced by meabench:mapprobetimes.
% STARTENDS must be a cell array of .startend filenames, produced by
% meabench:findprobetimes.
% CR must be an array of column-row indices. One plot is produced for
% each. [NYI: only the first item is used]
% TMIN_MS, TMAX_MS limit the horizontal scale of the graph.
% The .startend files may be manually augmented with labels to be
% plotted just before the section. Such labels must be enclosed by
% double quotes.

if (length(files) ~= length(startends))
  error('Length of FILES and STARTENDS arguments must be the same');
end

hw=cr12hw(cr(1));
tmin_s=tmin_ms/1000;
tmax_s=tmax_ms/1000;

prevend=0;

for i=1:length(files)
  fprintf(2,'Loading file %i, "%s"\n',i,files{i});
  spks=load(files{i},'-ascii');
  [t_start,t_end,lbl] = textread(startends{i},'%n %n %q');
  t_start=min(spks(:,6))-15; t_end=max(spks(:,6))+15; % Hmmm.
  
  if (prevend>0)
    if (prevend<t_start)
      x0=tmin_ms;
      x1=tmax_ms;
      y0=prevend;
      y1=t_start;
      patch([x0 x1 x1 x0 x0],[y0 y0 y1 y1 y0],[.9 .9 .8]);
    end
  end

  idx=find(spks(:,2)==hw);
  spks=spks(idx,[1 6]);
  idx=find(spks(:,1) >= tmin_s & spks(:,1) <= tmax_s);
  spks=spks(idx,:);
  plot(spks(:,1)*1000,spks(:,2),'.');
  prevend = t_end;
  if (length(lbl{1}) > 0)
    t=text(tmin_s, t_start,[lbl{1} '   ']);
    set(t,'HorizontalAlignment','right');
  end
  hold on
end
ytick=get(gca,'YTick');
for i=1:length(ytick)
  [a ytickl{i}]=unix(['perl -e "use POSIX; print POSIX::strftime(\"%D %H:%M:%S\",localtime(' ...
                      num2str(ytick(i)) ...
	  	      ')), \"\";"']);
end
set(gca,'YTick',ytick);
set(gca,'YTickLabel',ytickl);
hold off
