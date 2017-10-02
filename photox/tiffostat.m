function pp = tiffostat(ima,imb,ord)
% TIFFOSTAT - Calculates a mapping from IMA to IMB, for RGB separately
%   pp = TIFFOSTAT(ima,imb,ird) extracts pixels from the overlap area of
%   IMA and IMB. It then fits a polynomial to map the red, green, and blue
%   channels from IMA to IMB.

[Y X C] = size(ima);
ima=reshape(ima,[Y*X C]);
imb=reshape(imb,[Y*X C]);
ok=~isnan(ima(:,1));
ima=ima(ok,:);
imb=imb(ok,:);

pp = zeros(ord+1,3);
for c=1:3
  pp(:,c) = polyfit(ima(:,c),imb(:,c),ord);
end
