load worldcoord.dat -ascii
pasadena=[-118.144 34.148]; % Real Pasadena
%pasadena=[110 1]; % Singapore
%pasadena=[4 53]; % Netherlands
phi=worldcoord(:,1)*pi/180;
theta=(90-worldcoord(:,2))*pi/180;
%xi=cos(PHI).*THETA;
%eta=sin(PHI).*THETA;
%plot(xi,eta,'.');
%print -dps hello.ps
%return;

phi=phi-pasadena(1)*pi/180;
z=cos(theta);
x=sin(theta).*cos(phi);
y=sin(theta).*sin(phi);
alpha=(90-pasadena(2))*pi/180;
X=cos(alpha)*x - sin(alpha)*z;
Y=y;
Z=sin(alpha)*x + cos(alpha)*z;

PHI=atan2(Y,X);
THETA=atan2(sqrt(X.^2+Y.^2),Z);

xi=cos(PHI).*THETA;
eta=sin(PHI).*THETA;
clf
axes('position',[0 0 1 1]);
p=plot(xi,eta)
%%  brks=find(isnan(xi));
%%  starts=brks(1:end)+1;
%%  ends=brks(2:end)-1;  ends=[ends; length(xi)];
%%  for i=1:length(starts);
%%    i/length(starts)
%%    a=fill(xi(ends(i):-1:starts(i)),eta(ends(i):-1:starts(i)),[0 0 1]);
%%    set(a,'EdgeColor',[0 1 0]);
%%    hold on
%%  end
%%  hold off
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gcf,'Papersize',[9 9]);
set(gcf,'PaperPosition',[.5 .5 8 8]);
rectangle('Curvature',[1 1],'Position',[-pi -pi 2*pi 2*pi])
axis(1.02*[-pi pi -pi pi]);
drawnow

