function co=loadcor(fn)
% co=LOADCOR(fn) loads the file fn, produced by spikexcor and 
% returns a cell matrix:
% co{from}{to}(n) describes the number of times a spike on 
% channel to (1..64, hardware numbers plus 1) occurred (n-nbins)*dt ms
% after a spike on channel from (1..64, hardware numbers plus 1).
% Here's how to plot 8x8 graphs of how all channels influence (left)
% channel hw, and respond to channel hw (right half):
%   for c=0:63, subplot(8,8,hw2cr(c)); plot([-49.5:49.5]*4,co{hw+1}{c+1});end;
% This assume there are 50 bins, each representing 4 ms.
% Here's how to generate the data file:
%   spikefilter '$h<-5*$sig[$c]' 3464.spike | spikeorder | spikexcor 50 100 > xcor12.txt 

xc=load(fn,'-ascii');
nbins = size(xc,2);
xc=reshape(xc,[64 64,nbins]);
%for c=1:64
%  scc{c} = xc(c,c,1);
%end
for c=1:64
  for d=1:64
%    if scc{c}*scc{d} > .001
%      xc(c,d,:) = xc(c,d,:) ./ sqrt(scc{c}*scc{d}); % scale to corrcoef.
%    else
%      xc(c,d,:) = -1; % nan -> -1
%    end
    co{c}{d}=cat(1,reshape(xc(c,d,[nbins:-1:1]),[nbins,1]),reshape(xc(d,c,:),[nbins,1]));
  end
end