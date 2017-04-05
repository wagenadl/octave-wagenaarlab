function cc = alphablend(aa, bb)
% ALPHABLEND - Compositing of RGBA images
%   cc = ALPHABLEND(aa, bb) where AA and BB are (Y,X,4) RGBA images produces
%   a (Y,X,4) output image with BB placed over AA.
%   If AA is (Y,X,3), the output will also be (Y,X,3) and the alpha channel
%   for AA will be assumed to equal 1 resulting in an output alpha that
%   also equals one.
%   It is also permitted for AA and BB to be (Y,X,2) GA images, and 
%   AA may be (Y,X,1).

% Equations derived in notebook C7:p35 and also on wikipedia.

Sa = size(aa);
Sb = size(bb);
if length(Sa)==2
  Sa(3) = 1;
end

Ca = Sa(end);
Cb = Sb(end);
if length(Sb)~=3 || (Cb~=4 && Cb~=2)
  error('alphablend: BB must be YxXx4 or YxXx2');
end
if length(Sa)~=3 || Ca<1 || Ca>4
  error('alphablend: AA must be YxXx{1, 2, 3, or 4}');
end

Sa0 = prod(Sa(1:2));
Sb0 = prod(Sb(1:2));
if Sa0~=Sb0
  error('alphablend: AA and BB must have same YxX');
end

aa = reshape(aa, [Sa0 Ca]);
bb = reshape(bb, [Sb0 Cb]);

if Ca>=3
  acol = aa(:,1:3);
else
  acol = aa(:,1);
end

if Cb>=3
  bcol = bb(:,1:3);
else
  bcol = bb(:,1);
end
balph = bb(:,end);

Cb1 = size(bcol, 2);
Ca1 = size(acol, 2);

if Ca1~=Cb1
  error('alphablend: Either AA and BB must both be RGB, or both grey');
end

cc = zeros(Sa0, Ca);
if Ca==3 || Ca==1
  % Simple case: opaque background
  for k=1:Ca1
    cc(:,k) = balph.*bcol(:,k) + (1-balph).*acol(:,k);
  end
else
  % Full case: semi-opaque background
  aalph = aa(:,end);
  calph = balph + (1-balph).*aalph;
  for k=1:Ca1
    cc(:,k) = (balph.*bcol(:,k) + (1-balph).*aalph.*acol(:,k)) ./ calph;
  end
  cc(:,Ca) = calph;
  cc(calph==0, :) = 0;
end

cc = reshape(cc, Sa);
