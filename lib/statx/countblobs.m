function n=countblobs(img,clr)
% n=COUNTBLOBS(img,clr) counts the number of contiguous areas of color CLR
% in image IMG. Color match must be exact.

inblob = img(:,:,1)==clr(1) & img(:,:,2)==clr(2) & img(:,:,3)==clr(3);
[X Y]=size(inblob);

starts=cell(1,Y+1);
ends=cell(1,Y+1);
for y=1:Y
  thisblob=inblob(:,y);
  starts{y+1}=find(diff([0; thisblob])>0);
  ends{y+1}=find(diff([thisblob; 0])<0);
end

% Now starts{y}, ends{y} are the starting and ending positions of all blobs
% on line y.

for y=2:Y+1
  K=length(starts{y});
  for k=1:K
    x0=starts{y}(k);
    x1=ends{y}(k);
    previdx = find(starts{y-1}<=x1 & ends{y-1}>=x0);
    if length(previdx)>1
      % Resolve U shaped blobs
      starts{y-1}=starts{y-1}([[1:previdx(1)] [previdx(end)+1:end]]);
      ends{y-1}=ends{y-1}([[1:previdx(1)-1] [previdx(end):end]]);
    end
  end
end

n=0;
for y=2:Y+1
  K=length(starts{y});
  over=zeros(1,K);
  for k=1:K
    x0=starts{y}(k);
    x1=ends{y}(k);
    over(k)=length(find(starts{y-1}<=x1 & ends{y-1}>=x0));
    % Does this blob overlap with any on previous line?
  end
  n=n+length(find(over==0));
  % Count only non-overlapping blobs
end

      
    