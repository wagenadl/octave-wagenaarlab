function tracer_drawrays(trc, x, altc)
% TRACER_DRAWRAYS - Draw traced rays
%    TRACER_DRAWRAYS(trc) draws the rays from the most recent
%    call to TRACER_TRACE. 
%    TRACER_DRAWRAYS(trc, x) specifies an endpoint differing from the image.
%    TRACER_DRAWRAYS(trc, x, 1) uses colors based on theta rather than y.

if nargin<2
  x = tracer_imagex(trc);
  qmarker o solid 3
  qmark(x, 0);
  ximg = x;
  xspec = [];
else
  ximg = [];
  xspec = x;
end
if nargin<3
  altc = 0;
end

[xx, yy] = tracer_rays(trc);
[N Y T] = size(xx);
xx(end,:,:) = x;
yy(end,:,:) = reshape(trc.y1 + trc.tantheta1.*x, [1 Y T]);

xmax = abs(trc.objx);
if isinf(xmax)
  xmax = 100;
end

cct = djet(T);
cc = djet(Y);
for y=1:Y
  if Y>1 && ~altc
    qpen(cc(y,:));
  end
  for t=1:T
    if T>1 && altc
      qpen(cc(t,:));
    end
    x_ = xx(:,y,t);
    y_ = yy(:,y,t);
    x_(abs(imag(x_))>1e-5) = nan;
    x_(abs(y_)>50) = nan;
    x_(abs(x_)>max(abs([2*xmax; 2*trc.xlens(:); xspec]))) = nan;
    x_ = real(x_);
    y_ = real(y_);
    qplot(x_, y_);
  end
end
