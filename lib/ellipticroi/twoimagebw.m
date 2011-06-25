function hh=twoimagebw(img1,img2)
% TWOIMAGEBEW(img1,img2) plots two images side by side in preparation for 
% IMAGEELLIPSES.

clf
set(gcf,'menubar','none');%,'numbertitle','off','name','Image ellipses');

w=512*2+30;
h=512+20;
s=2;
x0=10; x1=512+20;
y0=10; y1=10;
ss=get(0,'screensize');
set(gcf,'position',[ss(3)-10-w ss(4)-30-h w h]);
hh(1)=axes('position',[x0/w y0/h s*256/w s*256/h]);
opticalimagebw(img1);
hh(2)=axes('position',[x1/w y1/h s*256/w s*256/h]);
opticalimagebw(img2);
