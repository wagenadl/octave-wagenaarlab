function [aa,bb]=smoothgon(a,b,n,r)
% [xx,yy] = SMOOTHGON(x,y,n,r) resamples the polygon defined by (X,Y) into 
% N points, and then blurs to radius R using gaussianblur1d. Resampling is 
% done with equidistant points.
l = sqrt(diff(a).^2+diff(b).^2);
sl = cumsum(l); sl=sl/sl(end);
nn=diff([0 ceil(sl*n)])+1;
nn(nn<2)=2;
aa=[];
bb=[];
for k=1:length(nn)
  aa=[aa interp1([0 1],a(k:k+1),[.5:nn(k)]/nn(k),'linear')];
  bb=[bb interp1([0 1],b(k:k+1),[.5:nn(k)]/nn(k),'linear')];
end
L=length(aa);
aa=gaussianblur1d([aa aa],r);
bb=gaussianblur1d([bb bb],r);
aa=aa([1:L]+ceil(L/2));
bb=bb([1:L]+ceil(L/2));
