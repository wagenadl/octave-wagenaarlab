function [dx,dy]=ofseq(ifn,fr1,frn)
% OFSEQ - Integrated motion from optical flow
%   [dx,dy] = OFSEQ(ifn,fr1,frn) loads optical flow from IFN, and
%   integrates frame FR1 through FRN, where IFN is created by COMBIFLOW.

flw=load(ifn);

frn=min(frn,length(flw.dx));

N = 1 + frn - fr1;

X=flw.X; Y=flw.Y;

if isnan(X)
  dx=[];
  dy=[];
  return
end

x0=repmat([1:X],[Y 1]); % Initial x-positions
y0=repmat([1:Y]',[1 X]); % Initial y-positions

xx=repmat([1:X],[Y 1]); % Moving x-positions
yy=repmat([1:Y]',[1 X]); % Moving y-positions

dx=zeros(Y,X,N);
dy=zeros(Y,X,N);
for n=1:N
  dx1 = interp2(x0,y0,double(flw.dx{n-1+fr1})/1000,xx,yy,'linear');
  dy1 = interp2(x0,y0,double(flw.dy{n-1+fr1})/1000,xx,yy,'linear');
  dx1(isnan(dx1))=0;
  dy1(isnan(dy1))=0;
  xx=xx+dx1;
  yy=yy+dy1;
  dx(:,:,n) = xx-x0;
  dy(:,:,n) = yy-y0;
end
