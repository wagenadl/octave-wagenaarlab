function showellipses(img1,img2,el1,el2)
% SHOWELLIPSES(img1,img2,el1,el2) redisplays the result of a previous 
% TWOIMELPS (or IMAGEELLIPSES).

hh = twoimagebw(img1,img2);

el{1} = normellipse(el1); el{2}=normellipse(el2);

for k=1:2
  [D N]=size(el{k});
  axes(hh(k));
  for n=1:N
    r = plotellipse(el{k},'color',[0 .5 1],'linew',2);
    t = text(el{k}(1,n),el{k}(2,n),sprintf('%i',n));
    set(t,'horizontala','center','color',[0 .5 1]);
  end
  axes(hh(3-k));
  for n=1:N
    r = plotellipse(el{k},'color',[0 .5 1],'linew',2,'linest','--');
  end
end

