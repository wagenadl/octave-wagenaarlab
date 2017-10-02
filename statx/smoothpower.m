function smoothpower(timedata,bins,samplefreq)
% SMOOTHPOWER(timedata,bins,samplefreq) plots a smoothed power spectrum of
% the given data.
% BINS is the optional number of data points to take in the smoothed
% spectrum. The default is 2000.
% SAMPLEFREQ is optional and defaults to 25000 Hz.
% This function only plots data from 10 Hz to 5000 Hz.

if nargin<2
  bins = 2000
end

if nargin<3
  samplefreq = 25000
end

minfreq = 10;
maxfreq = 5000;

t0 = length(timedata)/samplefreq;
freqdata = fft(timedata);
nn=floor(length(freqdata)/2);
freqdata=freqdata(2:nn); % Drop DC, drop echos
ff=[1:length(freqdata)] .* (1/t0);
pw = freqdata .* conj(freqdata);

%loglog(ff,pw,'b-'); % Plot unsmoothed

maxlog=log(ff(length(ff)));
minlog=log(minfreq); maxlog=log(maxfreq);
logsteps=[0:bins]/bins * (maxlog-minlog) + minlog;
logsteps=cat(2,logsteps,log(samplefreq));
freqstops = exp(logsteps);
smoothed = zeros(1,length(logsteps));
smidx=1; smn=0.0001; smsum=0;
maxidx=floor(maxfreq/(1/t0));
for pwidx=1:maxidx
  if ff(pwidx) >= freqstops(smidx)
    smoothed(smidx) = smsum/smn;
    smn=0; smsum=0; smidx = smidx+1;
    freqstops(smidx)
  end
  smn = smn+1;
  smsum = smsum + pw(pwidx);
end
n=length(freqstops);
smoothed=smoothed(2:(n-1));
freqcenter=(freqstops(1:(n-2))+freqstops(2:(n-1)))/2;

loglog(freqcenter,smoothed,'r-');
