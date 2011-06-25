function [pw,tt,ff] = dspecgram(yy, dt_step, dt_win, dt, plotflag)
% [pw,tt,ff] = DSPECGRAM(yy, dt_step, dt_win, dt, plotflag)

if nargin<4
  dt=1;
end

if nargin<5
  plotflag=0;
end

N=length(yy);
t0 = [1:dt_step:N-dt_win+1];
t1 = t0+dt_win-1;
K = length(t0);
F = dt_win/2;
pw = zeros(K,F);
ff = [0:F-1]/F / dt / dt_win;
tt = (t0+t1)'/2;
%ff = repmat([0:F-1]*(1/dt_win),[K 1]);
%tt = repmat((t0+t1)'/2,[1 F]);
for k=1:K
  y_ = yy(t0(k):t1(k));
  p_ = fft(y_);
  pw(k,:) = p_(1:F) .* conj(p_(1:F));
end

if plotflag
  imagesc(tt,ff,log(pw'+1e-99));
  set(gca,'ydir','norm');
end
