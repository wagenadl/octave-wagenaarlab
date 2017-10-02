function fitoflow(ifn,ofn)
% FITOFLOW - Fit a nice function to optic flow data
%    FITOFLOW(ifn,ofn) loads data from IFN, which must be flow-XX.mat,
%    integrates the optic flow, and fits curves to it.

study_frame = 40; % I.e., several frames after poker release.
scale_code  = 1;  % I.e., use the 'v1' series.
blur_radius = nan;% In pixels of the scaled image. (For v1, the scaled image
                  % is 320x240 pixels.)
fit_step = 1;     % Only do fits every N columns.

% We fit dy = A sin(B*(y-C)) * exp(-.5*(y-C)^2/D^2), where y is
% the longitudinal coordinate along the leech. This gets done at each
% circumferential position.
%
% We then calculate the contraction as max(dy)-min(dy) * -sign(A). (Note
% that B>0 by convention.)

[dx,dy]=ofseq(ifn,2,study_frame);

[Y,X,N] = size(dy);
if N+1<study_frame
  study_frame = N+1;
end

dy = dy(:,:,end);
if ~isnan(blur_radius)
  dy = gaussianblur(dy,blur_radius);
end

B=pi; C=0; D=.4;

% From here on, 'x' represents the longit. coord., because PHYSFIT calls
% the indep. var. 'x'. Before this line, longit. coord. was usually called 'y'.


x=[-Y/2+1:1.5*Y]'; x=x-mean(x); x=x/(Y/2); 

% From here on, 'y' represents displacement, because PHYSFIT calls the
% dependent variable 'y'. Before this line, displacement was usu. called 'dy'.

y_0=zeros(floor(Y/2),1); % Define zero motion outside defined region.
y_1=zeros(ceil(Y/2),1); % Define zero motion outside defined region.

sinexp=sin(B*(x-C)).*exp(-.5*(x-C).^2/D^2);
sinexp=sinexp/max(sinexp);

xx=[1:fit_step:X]; K=length(xx);

A=zeros(1,K);
for k=1:K
  y=[y_0; dy(:,xx(k)); y_1];
  A(k)=sum(y.*sinexp) / sum(sinexp.^2);
end

fprintf(1,'FITOFLOW %s: Fitting.\n',ifn);
AA=zeros(1,K)+nan;
BB=zeros(1,K)+nan;
CC=zeros(1,K)+nan;
DD=zeros(1,K)+nan;
%EE=zeros(1,K)+nan;
p=cell(1,K);
for k=1:K
  y=[y_0;dy(:,xx(k));y_1];
  p0=[A(k) B C D];
  p{k}=physfit('A*sin(B*(x-C)) .* exp(-.5*(x-C).^2/D^2)',x,y,[],[],p0);
  if p{k}.ok
    AA(k) = p{k}.p(1);
    BB(k) = p{k}.p(2);
    CC(k) = p{k}.p(3);
    DD(k) = p{k}.p(4);
    %    EE(k) = p{k}.p(4);
  end
end

idx=find(BB<0);
AA(idx)=-AA(idx); BB(idx)=-BB(idx);

contr=zeros(1,K)+nan;
dcontr=zeros(1,K)+nan;

fprintf(1,'FITOFLOW %s: Calculating contraction\n',ifn);
for k=1:K
  if p{k}.ok
    z=AA(k)*sin(BB(k)*(x-CC(k))) .* exp(-.5*(x-CC(k)).^2/DD(k)^2);
    dzd=zeros(length(z),4);
    dzd(:,1) = sin(BB(k)*(x-CC(k))) .* exp(-.5*(x-CC(k)).^2/DD(k)^2);
    dzd(:,2) = AA(k)*(x-CC(k)).*cos(BB(k)*(x-CC(k))) .* ...
	       exp(-.5*(x-CC(k)).^2/DD(k)^2);
    dzd(:,3) = -AA(k)*BB(k)*cos(BB(k)*(x-CC(k))) .* ...
	       exp(-.5*(x-CC(k)).^2/DD(k)^2) + ...
	       z .* -(x-CC(k))/DD(k)^2;
    dzd(:,4) = z .* (x-CC(k)).^2/DD(k)^3;

    dzMM=0;
    dzMm=0;
    dzmm=0;
    [Mz Mi]=max(z);
    [mz mi]=min(z);
    for n=1:4
      for m=1:4
	dzMM=dzMM+dzd(Mi,n).*dzd(Mi,m).*p{k}.cov(n,m);
	dzMm=dzMm+dzd(Mi,n).*dzd(mi,m).*p{k}.cov(n,m);
	dzmm=dzmm+dzd(mi,n).*dzd(mi,m).*p{k}.cov(n,m);
      end
    end
    contr(k) = (Mz-mz) * sign(-AA(k));
    dcontr(k) = sqrt(dzMM+2*dzMm+dzmm);
  end
end
save(ofn,'xx','p','contr','dcontr',...
    'study_frame','blur_radius','fit_step');
