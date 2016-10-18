wvl = 935;
yy = [0 1 2];
th = [0:3:12]*pi/180;
trc = tracer_construct(0, yy, th);
trc = tracer_addlens(trc, ac254050b, 43.051, 0, 3);
trc = tracer_trace(trc, wvl);
std(tracer_conjugatexx(trc))

qfigure('/tmp/s1', 10, 4);
tracer_drawsystem(trc, 100);
tracer_drawrays(trc, 100);

trc = tracer_construct(0, yy, th);
trc = tracer_addlens(trc, ac254100b, 43.253, 1, 3);
trc = tracer_trace(trc, wvl);
x01 = trc.xx(end-1,:,:);
trc = tracer_addlens(trc, ac254100b, max(x01(:))+.01, 0, 3);
trc = tracer_trace(trc, wvl);
std(tracer_conjugatexx(trc))

qfigure('/tmp/s2', 10, 4);
tracer_drawsystem(trc, 110);
tracer_drawrays(trc, 110);