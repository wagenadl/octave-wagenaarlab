function im=pixeracell(im)
im=reshape(im,[4 (960/4) 1260]);
im=shiftdim(im,2);
im=reshape(im,[5 (1260/5) 4 (960/4)]);
im=double(im);
  
r=120;

row = reshape(shiftdim(im(:,:,:,r),2),[20 252]);
K=fminsearch(@minimi,eye(20),[],row);
nice=K*row;

figure(1); clf
colormap(repmat([1:256]'/256,1,3))
subplot(2,1,1);
imagesc(reshape(row,4,1260));
subplot(2,1,2);
imagesc(reshape(nice,4,1260));
return


function E=minimi(K,row)
%figure(3); imagesc(K); colorbar; drawnow
%det(K)
K=K./det(K);
E=sum(sum((K*row).^2));
