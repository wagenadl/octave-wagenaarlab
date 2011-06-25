function [omega,phi,amp] = fitsine2(tt,yy,omega0,phi0,amp0)
% [omega,phi,amp] = FITSINE2(tt,yy,omega0,phi0,amp0) fits a sine wave to the
% data YY. 
% Fitted function: yy = amp * COS(omega*tt + phi).
% It is critical that good estimates of OMEGA, PHI, and AMP are
% prepared first. See FITSINE for a way to get them.
% [omega,phi,amp] = FITSINE2(tt,yy) automatically calls FITSINE first.

if nargin<5
  [omega0,phi0,amp0] = fitsine(tt,yy);
end

p = fminsearch(@fitsine2_err,[omega0,phi0,amp0],[],tt,yy);
omega=p(1);
phi=p(2);
amp=p(3);

function err = fitsine2_err(p,tt,yy)
err = sum((yy-p(3)*cos(p(1)*tt+p(2))).^2);
