function xx = tracer_imagexx(trc)
% TRACER_IMAGEXX - X-position of the image of all object points
%   xx = TRACER_IMAGEX(trc) returns the position along the optical axis
%   of the image of each of the points in the tracer system TRC according
%   to the most recent call to TRACER_TRACE.

[N Y T] = size(trc.xx);
if T>1
  xx = zeros(Y,1) + nan;
  for y=1:Y
    y1 = trc.y1(y,:);
    th1 = trc.tantheta1(y,:);
    % The rays are defined by y = y1 + th1*x.
    % The image is at the x value where var(y) is minimal.
    % I will write:
    % y_avg = 1/N sum_n(y1_n + th1_n * x)
    % y_var = 1/N sum_n((y1_n + th1_n * x - y_avg)^2).
    % y_var = 1/N sum_n((yn + tn*x - 1/N sum_m(ym + tm*x))^2).
    % Minimizing means d y_var / dx = 0.
    % First, take x out of the inner sum:
    % y_var = 1/N sum_n((yn + tn*x - 1/N sum_m(ym) - 1/N sum_m(tm)*x)^2).
    % 0 = sum_n[(tn - 1/N sum_m(tm)) * (yn + tn*x - 1/N sum_m(ym) - 1/N sum_m(tm)*x)]
    % 0 = sum_n((tn - avgt) * (yn - avgy + (tn-avgt)*x))
    % x = - sum_n((tn - avgt) * (yn - avgy)) / sum_n((tn - avgt)^2).
    % I feel I should have been able to figure that out without that effort.
    avgt = mean(th1);
    avgy = mean(y1);
    xx(y) = -sum((th1-avgt).*(y1-avgy)) ./ sum((th1-avgt).^2);
  end
else
  y1 = trc.y1;
  th1 = trc.tantheta1;
  % See above for calculation.
  avgt = mean(th1);
  avgy = mean(y1);
  xx = -sum((th1-avgt).*(y1-avgy)) ./ sum((th1-avgt).^2);
end