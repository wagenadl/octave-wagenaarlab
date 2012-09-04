function cc = alphablend(aa, bb)
% ALPHABLEND - Compositing of RGBA images
%   cc = ALPHABLEND(aa, bb) where AA and BB are (Y,X,4) RGBA images produces
%   a (Y,X,4) output image with BB placed over AA.
%   If AA is (Y,X,3), the output will also be (Y,X,3) and the alpha channel
%   for AA will be assumed to equal 1 resulting in an output alpha that
%   also equals one.

% Equations derived in notebook C7:p35 and also on wikipedia.

Sa = size(aa);
Sb = size(bb);
Ca = Sa(end);
Cb = Sb(end);
if Cb~=4
  error('alphablend: BB must be YxXx4');
end
if Ca<3 || Ca>4
  error('alphablend: AA must be YxXx3 or YxXx4');  
end

Sa0 = prod(Sa(1:end-1));
Sb0 = prod(Sb(1:end-1));
if Sa0~=Sb0
  error('alphablend: AA and BB must have same YxX');
end

aa = reshape(aa, [Sa0 Ca]);
bb = reshape(bb, [Sb0 Cb]);

acol = aa(:,1:3);
bcol = bb(:,1:3);
balph = bb(:,4);

cc = zeros(Sa0, Ca);
if Ca==3
  % Simple case: opaque background
  for k=1:3
    cc(:,k) = balph.*bcol(:,k) + (1-balph).*acol(:,k);
  end
else
  % Full case: semi-opaque background
  aalph = aa(:,4);
  calph = balph + (1-balph).*aalph;
  for k=1:3
    cc(:,k) = (balph.*bcol(:,k) + (1-balph).*aalph.*acol(:,k)) ./ calph;
  end
  cc(:,4) = calph;
end

cc = reshape(cc, Sa);
