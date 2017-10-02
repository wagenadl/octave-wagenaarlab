function [w,h]=measurewh(context,range,tst)
% [w,h]=MEASUREWH(context,range) returns better width and height
% estimates of the spikes with given CONTEXT.
% It is recommended to limit the range of searching for the peak:
% [w,h]=measurewh(spks.context,[10:50]);

[T N]=size(context);

if nargin<2
  range=[10:50];
end
range=range(:)';

w=zeros(1,N);
h=zeros(1,N);
avg=mean(context);
context=context-repmat(avg,[T 1]);
pkl=min(context(range,:));
pkh=max(context(range,:));
for n=1:N
  if -pkl(n) > pkh(n)
    % Downgoing spike (assuming it's cleaned!)
    h(n)=pkl(n);
    w(n)=length(find(context(range,n)<=pkl(n)/2));
  else
    % Upgoing spike
    h(n)=pkh(n);
    w(n)=length(find(context(range,n)>=pkh(n)/2));
  end
end

if nargin>=3
  plot(context);
  line([25-w 25+w],[h h]);
  line([25 25],[h+1 h-1]);
end