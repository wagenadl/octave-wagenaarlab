function p = quartileplot(xx,y25,y50,y75,w,wb,varargin)
% p = QUARTILEPLOT(xx,y25,y50,y75,wcent,wedge)

if nargin<5 | isempty(w)
  w=median(diff(xx))/8;
end

if nargin<6 | isempty(wb)
  wb=2*w;
end

if prod(size(w))==1
  w = repmat(w,size(xx));
end

if prod(size(wb))==1
  wb = repmat(wb,size(xx));
end

x_=[];
y_=[];

for n=1:length(xx)
  x_ = [x_  xx(n)-w(n) xx(n)-wb(n) xx(n)+wb(n) xx(n)+w(n) ...
	xx(n)+wb(n) xx(n)-wb(n) xx(n)-w(n) xx(n)+w(n) nan];
  y_ = [y_  y50(n) y75(n) y75(n) y50(n) y25(n) y25(n) y50(n) y50(n) nan];
end

if ~isempty(x_)
  x_=x_(1:end-1);
  y_=y_(1:end-1);
end

p = plot(x_,y_,varargin{:});

