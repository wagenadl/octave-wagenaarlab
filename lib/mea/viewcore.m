function viewcore(ifn)

load(ifn)

clf
plot(tri.tms/3600,tri.raw(:,3),'rx','markers',3);
hold on
plot(tri.tms/3600,tri.stm*100,'bx','markers',3);
axis([spk.tms(1)/3600 spk.tms(end)/3600 0 6000]);
