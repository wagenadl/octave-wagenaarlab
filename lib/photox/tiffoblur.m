function [ima,imb] = tiffoblur(ima,imb,rx)
% TIFFOBLUR - Blurs the result of TIFFOVERLAP
%   [ima,imb] = TIFFOBLUR(ima,imb,rx) blurs the two images IMA and IMB 
%   using GSMOOTH with radius RX.
%   It then sets all pixels to NaN that have (partial) transparency in
%   either image.

ima=double(ima);
imb=double(imb);
ima=permute(gsmooth(permute(gsmooth(ima,rx),[2 1 3]),rx),[2 1 3]);
imb=permute(gsmooth(permute(gsmooth(imb,rx),[2 1 3]),rx),[2 1 3]);

msk = ima(:,:,4)<240 | imb(:,:,4)<240;
[Y X C]=size(ima);
ima=reshape(ima,[Y*X C]);
imb=reshape(imb,[Y*X C]);
ima(msk,:)=nan;
imb(msk,:)=nan;
ima=ima(:,1:3);
imb=imb(:,1:3);
ima=reshape(ima,[Y X 3]);
imb=reshape(imb,[Y X 3]);
