function [shft,adifs] = bestalign(im1,im2,wei,maxshft)

[Y X] = size(im1);

shft = zeros(2,1);

ima = double(im1(maxshft+1:end-maxshft,maxshft+1:end-maxshft));
wei = double(wei(maxshft+1:end-maxshft,maxshft+1:end-maxshft));

sm1 = sum(sum(wei));
smx = sum(sum(ima.*wei));
smxx = sum(sum(ima.^2.*wei));
mn = smx./sm1;
va = smxx./sm1 - smx.*smx./sm1.^2;
ima = (ima-mn)./va;

dirx = [ -1 0 1 0 -1 -1 1 1];
diry = [ 0 -1 0 1 -1 1 -1 1];
D=length(dirx);

bestdx=0;
bestdy=0;
dx=bestdx; dy=bestdy;
imb = double(im2(maxshft+1-dy:end-maxshft-dy,maxshft+1-dx:end-maxshft-dx));
smx = sum(sum(imb.*wei));
smxx = sum(sum(imb.^2.*wei));
mn = smx./sm1;
va = smxx./sm1 - smx.*smx./sm1.^2;
imb = (imb-mn)./va;
bestdif = sum(sum(wei.*(ima-imb).^2));
adifs=zeros(2*maxshft+1)+nan;
while 1
  ddif = zeros(1,D)+inf;
  for d=1:D
    dx=bestdx+dirx(d); dy=bestdy+diry(d);
    if dx>=-maxshft & dx<=maxshft & dy>=-maxshft & dy<=maxshft
      if isnan(adifs(dy+maxshft+1,dx+maxshft+1))
	imb = double(im2(maxshft+1-dy:end-maxshft-dy,maxshft+1-dx:end-maxshft-dx));
	smx = sum(sum(imb.*wei));
	smxx = sum(sum(imb.^2.*wei));
	mn = smx./sm1;
	va = smxx./sm1 - smx.*smx./sm1.^2;
	imb = (imb-mn)./va;
	dif = sum(sum(wei.*(ima-imb).^2));
	adifs(dy+maxshft+1,dx+maxshft+1) = dif;
      end
      ddif(d) = adifs(dy+maxshft+1,dx+maxshft+1);
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
  shft(1) = bestdy;
  shft(2) = bestdx;
end
