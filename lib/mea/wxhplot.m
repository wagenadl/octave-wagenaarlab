function wxhplot(w,h,sty)
x=w+rand(size(w))-.5;
y=h+rand(size(h))-.5;
x=x./25;
y=y.*341/2048;
plot(x,y,sty);
