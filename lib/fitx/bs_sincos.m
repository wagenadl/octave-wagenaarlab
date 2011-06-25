function bs = bs_sincos(xx,yy,omega,N,p)
% BS_SINCOS - Fit periodic data using bootstrap estimate
%    bs = BS_SINCOS(xx,yy,omega,N) fits the data (XX,YY) to the function
%
%       Y = A cos(omega X) + B sin(omega X)
%
%    using bootstrap, taking N samples.
%    Result is a structure with fields:
%
%      A:  estimate for A
%      dA: estimate for standard error of A
%      B:  estimate for B
%      dB: estimate for standard error of B
%
%    For convenience, the results are also recalculated as a fit to
%
%       Y = M cos(omega X + phi),
%
%    and the structure will contain fields Y, dY, phi, dphi accordingly.
%
%    CAUTION: The value of M may be an overestimate, since even in pure noise
%    there will be an optimal direction phi.
%
%    Note that this effectively calculates A and B as Fourier components:
%    if the data really is something like
%
%      yy = A cos(omega X) + B sin(omega X) + C cos(2 omega X) + D,
% 
%    the values of C and D will not affect the estimates for A, B, dA, and dB.
%
%    bs = BS_SINCOS(...,p) also calculates a lower bound confidence interval
%    on M, that is a value M0, s.t. Prob(M<M0) <= P. Note that M is biased
%    because we are calculating it as the mean in the direction of optimal phi.
%    Thus, its expectation value is bs.EM rather than 0, and results should
%    be considered significant only if M0>EM.

ab = dbootstrap(N,@csfit,xx/omega,yy);

mab = mean(ab);
sab = std(ab);

bs.A=mab(1);
bs.dA=sab(1);
bs.B=mab(2);
bs.dB=sab(2);

% Foll. is a bad (biased) estimate of M
mmm = sqrt(ab(:,1).^2 + ab(:,2).^2);
bs.M1 = mean(mmm);
bs.dM1 = std(mmm);

% Calculating phi is slightly tricky, because phi is defined modulo 2*pi,
% so if the real phi is close to -pi or +pi, we would get bad results from
% wrapping. Therefore, in the following, instead of calculating phi in
% [-pi,pi), we calculate it in [phi0-pi,phi0+pi), where phi0 is the angle
% of (A,B).
phi = atan2(ab(:,2),ab(:,1));
phi0=atan2(bs.B,bs.A);
phi=mod(phi-phi0+pi,2*pi)-pi+phi0;
bs.phi = mod(mean(phi)+pi,2*pi)-pi;
bs.dphi = std(phi);

% Estimate M as component in direction phi. Still not quite unbiased,
% but a lot better than the other one.
mmm = ab(:,1).*cos(phi0) + ab(:,2).*sin(phi0);
bs.M = mean(mmm);
bs.dM = std(mmm);

% The problem is this:
% Let X and Y both be distributed N(0,1). Now calculate the optimal angle
% as phi = atan2(mean(Y),mean(X)), and then calculate the magnitude as
%
% M = mean(x)*cos(phi) + mean(y)*sin(phi)
%   = mean(x)*mean(x)/sqrt(mean(x)^2+mean(y)^2) + mean(y)*mean(y)/sqrt(mean(x)^2+mean(y)^2)
%   = sqrt(mean(x)^2 + mean(y)^2).
%
% Now, even though the expectation value of mean(x) is zero, the expectation
% value of mean(x)^2 certainly is not. In fact,
%
% E[mean(x)^2] = int(dx_1)..int(dx_n) / sqrt(2pi)^n exp(-1/2 sum(x^2_i)) *
%                (sum_j(x_j)/n)^2
%              = int(dx_1)..int(dx_n) / sqrt(2pi)^n exp(-1/2 sum(x^2_i)) *
%                (1/n^2) sum_j(x_j) sum_k(x_k)
%              = int(dx_1)..int(dx_n) / sqrt(2pi)^n exp(-1/2 sum(x^2_i)) *
%                (1/n^2) sum_jk(x_j x_k delta_jk)
%              = int(dx_1)..int(dx_n) / sqrt(2pi)^n exp(-1/2 sum(x^2_i)) *
%                (1/n^2) n
%              = 1/n,
%
% because int(dx) exp(-1/2 x^2) = int(dx) exp(-1/2 x^2) x^2 = 1.
%
% Thus, E[M] = E[sqrt(mean(x)^2+mean(y)^2)]
%            = sqrt(E[mean(x)^2] + E[mean(y)]^2)
%            = sqrt(2/n).
%
% So, to prove that the value of M really is significant, I have to prove
% that it is significantly greater than this null expectation value, which
% is a stronger requirement than proving that it is greater than zero.
% OK. Let's assume that X is N(A,dA) distributed, and Y is N(B,dB) distrd.
% Under the null hypothesis, dA and dB should be the same, so in fact, I can
% take:
s0 = std([ab(:,1)-bs.A; ab(:,2)-bs.B]);
bs.EM = s0*sqrt(2);
% Or, nearly the same: bs.EM = sqrt(bs.dA^2+bs.dB^2);

if nargin>=5
  if p>0
    mmm=sort(mmm);
    N0=floor(N*p);
    if N0==0
      bs.M0=0;
    else
      bs.M0=mmm(N0);
    end
  else
    bs.mmm=mmm;
    bs.aaa=ab(:,1);
    bs.bbb=ab(:,2);
    bs.phiii=phi;
  end
end


%----------------------------------------------------------------------
function AB = csfit(xx,yy)
AB = [sum(cos(xx).*yy) ./ sum(cos(xx).^2),  ...
      sum(sin(xx).*yy) ./ sum(sin(xx).^2)];
