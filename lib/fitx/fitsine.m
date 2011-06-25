function [omega,phi,amp] = fitsine(tt,yy,omega_max,omega_min)
% [omega,phi,amp] = FITSINE(tt,yy) fits a sine wave to the data YY(TT).
% [omega,phi,amp] = FITSINE(tt,yy,omega_max,omega_min) specifies a range
% of frequencies to try.
% Fitted function: yy = amp * COS(omega*tt + phi).
% This function is very good at local optimum avoidance.
% However, it appears that it is biased to smaller AMP. See FITSINE2
% for a complementary approach based on FMINSEARCH.

dt=max(tt)-min(tt);
if nargin<4
  omega_min = 1/dt;
end
if nargin<3
  omega_max = 1000/dt;
end

if length(omega_max)==2
  omega_min = min(omega_max);
  omega_max = max(omega_max);
end

if omega_min > omega_max
  [omega_min, omega_max] = identity(omega_max, omega_min);
end

log_omega_min = log(omega_min);
log_omega_max = log(omega_max);
log_domega = log(1.05); % Initially step by 5%
REFINEMENTS = 3;
REFINEMENTFAC = 5;
REFINEMENTRANGE = 10;
for ref=1:REFINEMENTS
  best_log_omega=nan;
  best_fit=0;
  for log_omega = log_omega_min:log_domega:log_omega_max
    fit = sum(yy.*sin(tt*exp(log_omega)))^2 + sum(yy.*cos(tt*exp(log_omega)))^2;
    if fit>best_fit
      best_log_omega = log_omega;
      best_fit = fit;
    end
  end
  %  fprintf(1,'best: %.3f (%.3f) [%.3f-%.3f (%.3g)]\n',exp(best_log_omega),best_fit,exp(log_omega_min),exp(log_omega_max),exp(log_domega)-1);
  log_omega_min = best_log_omega - REFINEMENTRANGE*log_domega;
  log_omega_max = best_log_omega + REFINEMENTRANGE*log_domega;
  log_domega = log(1+(exp(log_domega)-1) / REFINEMENTFAC);
end
omega = exp(best_log_omega);

fit_s = sum(yy.*sin(tt*omega));
fit_c = sum(yy.*cos(tt*omega));
phi = - atan2(fit_s,fit_c);

amp = 2 * sqrt(fit_s^2+fit_c^2) / length(tt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Testing
function testfitsine
tt=[0:.001:30];
omega=1; phi=.3;
yy=cos(tt*omega+phi);
zz=yy+randn(size(tt))*.3;
ww=yy+.5*cos(tt*omega*3+.6);
xx=yy+2*cos(tt*omega*3+.6);
aa=yy+randn(size(tt))*2.3;

figure(1); clf
[omega,phi,amp] = fitsine(tt,yy);
[omega_,phi_,amp_] = fitsine2(tt,yy,omega,phi,amp);
plot(tt,yy,'b', tt,amp*cos(tt*omega+phi),'r',tt,amp_*cos(tt*omega_+phi_),'g');
title(sprintf('y = %.3f cos(%.3f t + %.3f) or %.3f cos(%.3f t + %.3f)',amp,omega,phi,amp_,omega_,phi_));

figure(2); clf
[omega,phi,amp] = fitsine(tt,zz);
[omega_,phi_,amp_] = fitsine2(tt,zz,omega,phi,amp);
plot(tt,zz,'b', tt,amp*cos(tt*omega+phi),'r',tt,amp_*cos(tt*omega_+phi_),'g');
title(sprintf('y = %.3f cos(%.3f t + %.3f) or %.3f cos(%.3f t + %.3f)',amp,omega,phi,amp_,omega_,phi_));

figure(3); clf
[omega,phi,amp] = fitsine(tt,ww);
[omega_,phi_,amp_] = fitsine2(tt,ww,omega,phi,amp);
plot(tt,ww,'b', tt,amp*cos(tt*omega+phi),'r',tt,amp_*cos(tt*omega_+phi_),'g');
title(sprintf('y = %.3f cos(%.3f t + %.3f) or %.3f cos(%.3f t + %.3f)',amp,omega,phi,amp_,omega_,phi_));

figure(4); clf
[omega,phi,amp] = fitsine(tt,xx);
[omega_,phi_,amp_] = fitsine2(tt,xx,omega,phi,amp);
plot(tt,xx,'b', tt,amp*cos(tt*omega+phi),'r',tt,amp_*cos(tt*omega_+phi_),'g');
title(sprintf('y = %.3f cos(%.3f t + %.3f) or %.3f cos(%.3f t + %.3f)',amp,omega,phi,amp_,omega_,phi_));


figure(5); clf
[omega,phi,amp] = fitsine(tt,aa);
[omega_,phi_,amp_] = fitsine2(tt,aa,omega,phi,amp);
plot(tt,aa,'b', tt,amp*cos(tt*omega+phi),'r',tt,amp_*cos(tt*omega_+phi_),'g');
title(sprintf('y = %.3f cos(%.3f t + %.3f) or %.3f cos(%.3f t + %.3f)',amp,omega,phi,amp_,omega_,phi_));
