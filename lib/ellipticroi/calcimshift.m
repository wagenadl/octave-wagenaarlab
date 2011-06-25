function [dx,dy] = calcimshift(imgs,R,idx)
% CALCIMSHIFT - Calculates optimal shift to stabilize an image over time
%    [dx,dy] = CALCIMSHIFT(imgs,R) where IMGS is YxXxT calculates
%    optimal shift over the central area ignoring, the edgemost R+1 pixels.
%    CALCIMSHIFT(imgs,R,idx) uses only frame numbers in IDX as a baseline;
%    default is to return shifts relative to the mean of all frames.

[Y X T]=size(imgs);

if nargin<3
  idx=[1:T];
end

% First, normalize the image
avg = mean(mean(imgs,1),2);
for t=1:T
  imgs(:,:,t) = (imgs(:,:,t) - avg(t))./avg(t);
end

% Calculate reference image as average over all or selected frames
im0 = mean(imgs(R+1:end-R,R+1:end-R,idx),3);
% ... and normalize it.
%%im0 = im0/mean(im0(:));

dx = zeros(T,1);
dy = zeros(T,1);
for t=1:T
  df=zeros(2*R+1,2*R+1);
  for xi=-R:R
    for yi=-R:R
      im1 = imgs(R+1+yi:end-R+yi,R+1+xi:end-R+xi,t);
      %%im1 = im1/mean(im1(:));
      df(yi+R+1,xi+R+1) = sum(sum((im1-im0).^2));
    end
  end
  [dx0,dy0] = fitcup(df);
  if R>2
    dx0=max(min(dx0,R-2),-R+2);
    dy0=max(min(dy0,R-2),-R+2);
    xx=repmat([-2:2]+dx0,[5 1]);
    yy=repmat([-2:2]'+dy0,[1 5]);
    df=interp2([-R:R],[-R:R]',df,xx,yy,'linear');
    %  df=df([-2:2]+dy0+R+1,[-2:2]+dx0+R+1);
    [dx1,dy1] = fitcup(df);
  else
    dx1=0;
    dy1=0;
  end
  dx(t)=dx0+dx1;
  dy(t)=dy0+dy1;
end
