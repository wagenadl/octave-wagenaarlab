function y=loadsalpaevent(fn)
fd=fopen(fn,'rb');
raw = fread(fd,[8 inf],'int16');

ti0 = raw(1,:); idx = find(ti0<0); ti0(idx) = ti0(idx)+65536;
ti1 = raw(2,:); idx = find(ti1<0); ti1(idx) = ti1(idx)+65536;
ti2 = raw(3,:); idx = find(ti2<0); ti2(idx) = ti2(idx)+65536;
ti3 = raw(4,:); idx = find(ti3<0); ti3(idx) = ti3(idx)+65536;
y.time = (ti0 + 65536*(ti1 + 65536*(ti2 + 65536*ti3)));

ti0 = raw(5,:); idx = find(ti0<0); ti0(idx) = ti0(idx)+65536;
ti1 = raw(6,:); idx = find(ti1<0); ti1(idx) = ti1(idx)+65536;
y.duration = (ti0 + 65536*ti1);

y.channel = raw(7,:);
