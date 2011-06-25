function clickscat1(spkfn, bytr, cr)
% CLICKSCAT1(spkfn,bytrfn,cr) plots a scattergram of all spikes on
% channel CR collected in BYTR (a matrix as loaded from
% meabench:bytrial), and allows the use to click on the spikes. Spike
% context from SPKFN is then displayed in a separate window.

idx=find(bytr(:,2)==cr12hw(cr));
spks=bytr(idx,[1 5 6]);
spks(:,1)=spks(:,1)*1000;

plot(spks(:,1),spks(:,2),'.');

clickspikes(spkfn, spks');
