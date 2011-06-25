function [w,h]=betterwh(context,range,tst)
% [w,h]=BETTERWH(context,range) returns better width and height
% estimates of the spikes with given CONTEXT.
% It is recommended to pass only a small part of the full context to
% this function, e.g: [w,h]=betterwh(spks.context,[15:35]);

[T N]=size(context);

if nargin<2
  range=[1:T];
end
range=range(:)';

avg=mean(context);
context=context-repmat(avg,[T 1]);
yy=sum(context(range,:).^2);
yyy=sum(context(range,:).^3);
yyt=sum(context(range,:).^2.*repmat(range',[1 N]));
yytt=sum(context(range,:).^2.*repmat(range.^2',[1 N]));
h=yyy./yy;
t=yyt./yy;
tt=yytt./yy;
w=sqrt(tt-t.^2);

if nargin>=3
  plot(context);
  line([25-w 25+w],[h h]);
  line([25 25],[h+1 h-1]);
end