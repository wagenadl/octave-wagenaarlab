function y=rictests(rics)
% y=RICTESTS(rics) performs all the F-tests and t-tests necessary to
% establish a list of predictive rics.
% Input is as from rolecluster. There are some parameters to be set in
% the code, following these comments.
% Output is: y{CR} are structures with members
% w0,h0,ww,hh,wh,n: 1xNROLES vectors copied from the input;
% t_height, t_width, F_height, F_width: as from ricttest, ricftest,
%                                       but vectorized (1xNROLES);
% p_sigheight, p_sigwidth: p_height, p_width from ricftest, vectorized;
% p_muheight, p_muheight: P_height, P_width (!) from ricttest, vectorized;
% p_weirdest: the smallest of the 4 p-values for this roles, but
%             p_muxxx is ignored if p_sigxxx is significant.
% Some statistics are printed as the function progresses.
% The first entry in the vector is not written - it would refer to the
% everything cluster.

SIGNISIG = .005;
SIGNIMU  = .005;
SIGNIWEIRD = .0025;
BIGSIG = .95;

Signi_sigw=0;
Signi_sigh=0;
Signi_muw=0;
Signi_muh=0;
Signi_weird=0;
Big_sigw=0;
Big_sigh=0;
Nroles=0;
for hw=0:59
  cr=hw2crd(hw);
  nroles=length(rics{cr});
  y{cr}.t_height=zeros(1,nroles);
  y{cr}.t_width=zeros(1,nroles);
  y{cr}.p_sigheight=.5*ones(1,nroles);
  y{cr}.p_sigwidth=.5*ones(1,nroles);
  y{cr}.p_muheight=.5*ones(1,nroles);
  y{cr}.p_muwidth=.5*ones(1,nroles);
  y{cr}.p_weirdest=.5*ones(1,nroles);
  y{cr}.w0=zeros(1,nroles);
  y{cr}.ww=zeros(1,nroles);
  y{cr}.h0=zeros(1,nroles);
  y{cr}.hh=zeros(1,nroles);
  y{cr}.wh=zeros(1,nroles);
  y{cr}.n=zeros(1,nroles);
  for r=2:nroles
    y{cr}.w0(r)=rics{cr}{r}.w0;
    y{cr}.h0(r)=rics{cr}{r}.h0;
    y{cr}.ww(r)=rics{cr}{r}.ww;
    y{cr}.hh(r)=rics{cr}{r}.hh;
    y{cr}.wh(r)=rics{cr}{r}.wh;
    y{cr}.n(r)=rics{cr}{r}.n;
    f=ricftest(rics{cr}{r},rics{cr}{1});
    t=ricttest(rics{cr}{r},rics{cr}{1});
    y{cr}.F_height(r)=f.F_height;
    y{cr}.t_height(r)=t.t_height;
    y{cr}.F_width(r)=f.F_width;
    y{cr}.t_width(r)=t.t_width;
    y{cr}.p_sigheight(r)=f.p_height;
    y{cr}.p_sigwidth(r)=f.p_width;
    y{cr}.p_muheight(r)=t.P_height;
    y{cr}.p_muwidth(r)=t.P_width;
    weird_height = f.p_height;
    if weird_height > SIGNISIG
      if t.P_height < weird_height
	weird_height = t.P_height;
      end
    end
    weird_width =  f.p_width;
    if weird_width > SIGNISIG
      if t.P_width < weird_width
	weird_width = t.P_width;
      end
    end
    y{cr}.p_weirdest(r) = min([weird_width weird_height]);
  end
  signi_sigw=length(find(y{cr}.p_sigwidth < SIGNISIG));
  signi_sigh=length(find(y{cr}.p_sigheight < SIGNISIG));
  signi_muw=length(find((y{cr}.p_sigwidth > SIGNISIG) & ...
      y{cr}.p_muwidth < SIGNIMU));
  signi_muh=length(find((y{cr}.p_sigheight > SIGNISIG) & ...
      y{cr}.p_muheight < SIGNIMU));
  signi_weird=length(find(y{cr}.p_weirdest < SIGNIWEIRD));
  big_sigw=length(find(y{cr}.p_sigwidth > BIGSIG));
  big_sigh=length(find(y{cr}.p_sigheight > BIGSIG));

  fprintf(1, ...
    'CR=%2i N=%3i sw=%2i sh=%2i mw=%2i mh=%2i ok=%2i bw=%2i bh=%2i\n', ...
    cr,nroles-1,signi_sigw, signi_sigh, signi_muw, signi_muh,  ...
    signi_weird, big_sigw, big_sigh);
  
  Signi_sigw =Signi_sigw +signi_sigw ;
  Signi_sigh =Signi_sigh +signi_sigh ;
  Signi_muw  =Signi_muw  +signi_muw  ;
  Signi_muh  =Signi_muh  +signi_muh  ;
  Signi_weird=Signi_weird+signi_weird;
  Big_sigw   =Big_sigw   +big_sigw   ;
  Big_sigh   =Big_sigh   +big_sigh   ;
  Nroles=Nroles+nroles-1;
end

fprintf(1, ...
    '\nTOTAL N=%3i sw=%2i sh=%2i mw=%2i mh=%2i ok=%2i bw=%2i bh=%2i\n', ...
    Nroles,Signi_sigw, Signi_sigh, Signi_muw, Signi_muh,  ...
    Signi_weird, Big_sigw, Big_sigh);
