function tracer_drawrays(trc, x)
% TRACER_DRAWRAYS - Draw traced rays
%    TRACER_DRAWRAYS(trc) draws the rays from the most recent
%    call to TRACER_TRACE. 
%    TRACER_DRAWRAYS(trc, x) specifies an endpoint differing from the image.

if nargin<2
  x = tracer_imagex(trc);
  qmarker o solid 3
  qmark(x, 0);
end

[xx, yy] = tracer_rays(trc);
[N Y T] = size(xx);
xx(end,:,:) = x;
yy(end,:,:) = reshape(trc.y1 + trc.tantheta1.*x, [1 Y T]);

xmax = abs(trc.objx);
if isinf(xmax)
  xmax = 100;
end

cc = djet(Y);
for y=1:Y
  qpen(cc(y,:), 0);
  for t=1:T
    x_ = xx(:,y,t);
    y_ = yy(:,y,t);
    x_(abs(imag(x_))>1e-5) = nan;
    x_(abs(y_)>50) = nan;
    x_(abs(x_)>2*max(abs([xmax; trc.xlens(:)]))) = nan;
    x_ = real(x_);
    y_ = real(y_);
    qplot(x_, y_);
  end
end
