function coolpixcontrast(ifn,ofn);

x=imread(ifn);
k=mean(x,3);
m=median(k(:));
l=atan((k-m)/150); % Make median neutral grey and stretch contrast a bit

if 1
  % Unsharp mask?
  cv=-fspecial('gaussian',11,3);
  d = conv2 ( l, cv, 'same');
  l=atan((l+.25*d)*2); % Unsharp mask requires further contrast stretching
end
k=sort(l(:)); K=length(k);

l0=k(ceil(.002*K)); l1=k(floor(.998*K));
l=(l-l0)/(l1-l0);
l(l<0)=0; l(l>1)=1;
y=uint8(l * 255.9999);

imwrite(y,ofn,'JPEG','quality',95);

