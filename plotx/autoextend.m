function act = autoextend(marg,n)
% AUTOEXTEND - Extend axes to encompass all text
%    AUTOEXTEND by itself creates 0.01 inch of space around all texts.
%    AUTOEXTEND(marg) specifies the marign.
%    act = AUTOEXTEND(...) returns true if the axes were changed.
%    This function automatically calls RECALCSHIFTS, and iterates if
%    needed.

if nargin<1
  marg=.01;
end

if nargin<2
  n=0;
end

a0 = axis;

a = a0;
hh=findobj(gca,'type','text');
for h=hh(:)'
  a = expandaxis(a,growbox(get(h,'extent'),marg));
end

axis(a);
recalcshifts;
da=a-a0;
chg = (da(1)^2+da(2)^2) / (a(2)-a(1))^2 + ...
    (da(3)^2+da(4)^2) / (a(3)-a(4))^2;
    
act = chg>.001;

if act & n<2
  if n==0
    autoextend(marg,n+1);
  else
    autoextend(0,n+1);
  end
end

if n==0
  a0 = axis;
  xywh = [a0(1) a0(3) a0(2)-a0(1) a0(4)-a0(3)];
  xywh = growbox(xywh,marg); 
  a0 = [xywh(1) xywh(1)+xywh(3) xywh(2) xywh(2)+xywh(4)];
  axis(a0);
end

if nargout<1
  clear act;
end
