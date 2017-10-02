function [pw,ttt,fff] = slowspec(yy,frqs,taus,f_s)
% [pw,ttt,fff] = SLOWSPEC(yy,frqs,taus) calculates spectral power of the
% data YY at all the frequencies in FRQS. This is done at multiple time points,
% with Gaussian windows determined by TAUS. 
% FRQS=1 corresponds to the sampling frequency. 
% [pw,ttt,fff] = SLOWSPEC(yy,frqs,taus,f_s) specifies the sampling 
% frequency, and enables plotting.
% Specify f_s<0 to disable plotting but still specify a sampling freq.
% (The output power is scaled by 1/f_s to give an answer in power / sqrt(Hz).)
% pw = SLOWSPEC(yy,frqs,taus) only returns the power map, in a 
% matrix of TxF where T is the length of YY and F is the length of FRQS.
% TAUS is optional, and defaults to 1/(2*pi) times the inverse of the 
% (variable) step size of FRQS. 
% If TAUS is a scalar, it is multiplied into 1/(2*pi) times the inverse of
% the (variable) step size of FRQS.

if nargin<3 | isempty(taus)
  taus=1;
end

if prod(size(taus))==1 % is it a scalar?
  df=diff(frqs(:));
  taus = taus ./ (([df(1); df] + [df; df(end)])/2   * 2*pi);
end

if nargin<4
  f_s=-1;
end

frqs = frqs;
T=length(yy);
F=length(frqs);

tt=[1:T];
if size(yy,2)==1
  tt=ttt';
end
for f=1:F
  tt0a = T/2+[0:taus(f)/4:T/2];
  tt0b = T/2-[taus(f)/4:taus(f)/4:T/2];
  tt0 = sort([tt0a tt0b]);
  tt0 = tt0(tt0>=1 & tt0<=T);
  N = length(tt0);
  fprintf(1,'%i/%i\r',f,F);
  a=zeros(1,N);
  b=zeros(1,N);
  omega = frqs(f)*2*pi;
  Nrm2 = pi^1.5*taus(f)/2 * abs(f_s);
  Thr = 1e-9;%.001*sqrt(Nrm2);
  for n=1:N
    ww = exp(-.5*(tt-tt0(n)).^2./taus(f).^2);
    idx = find(ww>Thr); 
    ww_ = ww(idx);    
    ww_ = ww_ * (sqrt(2*pi)*taus(f)) ./ sum(ww_); % Fix normalization to correct for edge effects
    yy_ = yy(idx);
    tt_ = tt(idx);
    a(n) = sum(yy_.*cos(omega*tt_).*ww_);
    b(n) = sum(yy_.*sin(omega*tt_).*ww_);
  end
  pw{f} = (a.^2+b.^2) / Nrm2;
  ttt{f} = tt0;
  fff{f} = frqs(f)+0*tt0;
end

if f_s>0 | nargout==1
  fprintf(1,'Interpolation\r');
  tt = [1:T]';
  ff = frqs(:);
  pw_ = zeros(length(tt),F)+nan;
  for f=1:F
    if length(ttt{f})>1
      pw_(:,f) = interp1(ttt{f},pw{f},tt,'spline');
      pw_(tt<ttt{f}(1),f)=pw{f}(1);
      pw_(tt>ttt{f}(end),f)=pw{f}(end);
    elseif length(ttt{f})==1
      pw_(:,f) = pw{f};
    end
  end
end
fprintf(1,'\n');

if f_s>0
  surf(tt/f_s,ff*f_s,pw_');
  shading interp
  axis tight
  view([0 90]);
end

if nargout==1
  pw = pw_;
  clear ttt
  clear fff
end

