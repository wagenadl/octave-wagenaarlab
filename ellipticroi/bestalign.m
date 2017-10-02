function [shft,difs,adifs] = bestalign(images,maxshft,src)
% shft = BESTALIGN(images,maxshft) computes best alignment for a stack of 
% images, relative to first image. MAXSHFT specifies maximum shift (in px).
% This is implemented as a simple hill climb from zero shift.
% [shft,difs] = BESTALIGN(...) returns final difference as well.
% [shft,difs,adifs] = BESTALIGN(...) returns image of all differences 
% considered.
% shft = BESTALIGN(images,maxshft,1) starts the climb from the result of 
% the prev. img.
% shft = BESTALIGN(images,maxshft,2) starts the climb from the result of 
% the img. before prev., etc.


if nargin<3
  src=0;
end

[Y X N] = size(images);

shft = zeros(2,N);
difs = zeros(1,N);
adifs = zeros(maxshft*2+1,maxshft*2+1,N)+nan;

ima = double(images(maxshft+1:end-maxshft,maxshft+1:end-maxshft,1));

dirx = [ -1 0 1 0 -1 -1 1 1];
diry = [ 0 -1 0 1 -1 1 -1 1];
D=length(dirx);

for n=2:N
  if N>2
    fprintf(1,'Bestalign: %i/%i\r',n,N);
  end
  if n>src+1 & src>0
    bestdy = shft(1,n-src);
    bestdx = shft(2,n-src);    
  else
    bestdx=0;
    bestdy=0;
  end
  dx=bestdx; dy=bestdy;
  imb = double(images(maxshft+1-dy:end-maxshft-dy,maxshft+1-dx:end-maxshft-dx,n));
  bestdif = sum(sum((ima-imb).^2));
  while 1
    ddif = zeros(1,D)+inf;
    for d=1:D
      dx=bestdx+dirx(d); dy=bestdy+diry(d);
      if dx>=-maxshft & dx<=maxshft & dy>=-maxshft & dy<=maxshft
	if isnan(adifs(dy+maxshft+1,dx+maxshft+1,n))
	  imb = double(images(maxshft+1-dy:end-maxshft-dy,maxshft+1-dx:end-maxshft-dx,n));
	  dif = sum(sum((ima-imb).^2));
	  adifs(dy+maxshft+1,dx+maxshft+1,n) = dif;
	end
	ddif(d) = adifs(dy+maxshft+1,dx+maxshft+1,n);
      end
    end
    [dif,whch] = min(ddif);
    if dif<bestdif
      bestdx = bestdx+dirx(whch);
      bestdy = bestdy+diry(whch);
      bestdif = dif;
    else
      break;
    end
  end
  shft(1,n) = bestdy;
  shft(2,n) = bestdx;
  difs(n) = bestdif;
end
if N>2
  fprintf(1,'Bestalign: Done.                    \n');
end

if nargout<2
  clear difs
end
if nargout<3
  clear adifs
end
