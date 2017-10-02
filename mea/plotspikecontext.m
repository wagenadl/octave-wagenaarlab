function plotspikecontext(fhandle,spikenr,figno)
% PLOTSPIKECONTEXT(fhandle,spikenr,figno) plots the context of one spike
% from a spike file.
% FHANDLE must be a file handle of an opened spikefile.
% SPIKENR must be a timeref_t spike index, counting from 0.
% FIGNO specifies which figure should be used to plot the context. If
% it is left unspecified, a new figure is created.
% After the call, the file pointer points to just after the spike.

% (C) DW Jun 20, 2001. Bugfix (<DB) Feb 24, 2005.
if nargin<3
  figure;
else
  figure(figno);
end

fseek(fhandle, spikenr*164,-1);
spike=fread(fhandle,[82 1],'int16');
context=spike(8:81); % Fixed!
tilo = spike(1); if tilo<0; tilo=tilo+65536; end
ti=tilo;
tilo = spike(2); if tilo<0; tilo=tilo+65536; end
ti=ti + tilo*65536;
tilo = spike(3); if tilo<0; tilo=tilo+65536; end
ti=ti + tilo*65536*65536;
tilo = spike(4); if tilo<0; tilo=tilo+65536; end
ti=ti + tilo*65536*65536*65536;

plot([-25:48]/25,context*341/2048);
xlabel('Time [ms]');
ylabel('Voltage [uV] (assuming gain=max)');
title(sprintf('Spike %i on channel %i at %g s',spikenr,spike(5),ti/25000));
