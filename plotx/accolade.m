function [X,Y]=accolade(x,y,w,h,theta)
% ACCOLADE(x,y,w,h,theta) plots an accolade ("{") centered at (X,Y)
% with width X and height Y, and rotated from the horizontal by THETA.
% (THETA=0 means -.- shape).
% p=ACCOLADE(...) returns a plot handle
% [X,Y]=ACCOLADE(...) doesn't plot but returns an array of points.
x_=[-1:.01:1];
y_=(abs(x_).^.5-(1-abs(x_)).^.5).^3;
x1=cos(theta)*x_-sin(theta)*y_;
y1=sin(theta)*x_+cos(theta)*y_;

if nargout==2
  X=x+x1*w;
  Y=y+y1*h;
else
  p=plot(x+x1*w,y+y1*h);
end
if nargout==1
  X=p;
end
