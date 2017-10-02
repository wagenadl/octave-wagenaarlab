function [pw, ff] = powspec(yy, fs, yunit, funit);
% POWSPEC - Naive power spectrum
%    pw = POWSPEC(yy, fs) calculates the power spectrum of the signal yy.
%    [pw, ff] = POWSPEC(yy, fs) returns frequencies as well.
%    The signal yy must be real. Only positive frequencies are returned;
%    power at negative frequencies is folded into positive frequencies.
%    Normalization is such that if the sampling frequency FS has units of
%    Hertz and YY has units of volts, then PW has units of volts^2/Hertz.
%    POWSPEC(yy, fs, yunit, funit) specifies alternate units for plotting

yy=yy(:);
T=length(yy);
pw = abs(fft(yy)).^2;
ff = [0:T-1]'/T * fs;
if mod(T,2)==0
  pw(2:T/2) = pw(2:T/2) + flipud(pw(T/2+2:end));
  ff = ff(1:T/2+1);
  pw = pw(1:T/2+1);
else

  pw(2:(T+1)/2) = pw(2:(T+1)/2) + flipud(pw((T+3)/2:end));
  ff = ff(1:(T+1)/2);
  pw = pw(1:(T+1)/2);
end
pw=pw/(T*T);
pw=pw/(ff(2)-ff(1));

if nargout==1
  clear ff
end
if nargout==0
  if nargin<4
    funit='Hz';
  end
  if nargin<3
    yunit='';
  end
  cla
  plot(ff,pw)
  xlabel(sprintf('Frequency (%s)',funit));
  if strcmp(yunit,'')
    ylabel(sprintf('Power (%s^{-1})',funit));
  else
    ylabel(sprintf('Power (%s^2/%s)',yunit,funit));
  end
  clear
end
