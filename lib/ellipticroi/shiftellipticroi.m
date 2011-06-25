function rho = shiftellipticroi(img,xyrra,r,orig)
% rho = SHIFTELLIPTICROI(img,xyrra,r,orig) extracts shifted elliptic ROIs
% from the image IMG, and computes the correlation with the originally 
% extracted ROI ORIG. 
% Return: a matrix of size (2R+1)x(2R+1) of correlation values. Shape: YxX!

L=length(orig);
rho = zeros(2*r+1)+nan;
for dx=-r:r
  for dy=-r:r
    xyrra_ = xyrra;
    xyrra_(1)=xyrra(1)+dx;
    xyrra_(2)=xyrra(2)+dy;
    pxs = extractellipticroi(img,xyrra_);
    if length(pxs)==L
      cc=corrcoef(orig,pxs);
      rho(dy+r+1,dx+r+1) = cc(1,2);
    end
  end
end
