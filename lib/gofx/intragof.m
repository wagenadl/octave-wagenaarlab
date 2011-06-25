function [dx,dy] = intragof(imgs)

[Y X N]=size(imgs);
tdir=tempname;
mkdir(tdir);
here=pwd;
cd(tdir);
for n=1:N
  fprintf(1,'intragof: saving image %i/%i...\r',n,N);
  ww=gaussianblur(imgs(:,:,n),5);
  img=imgs(:,:,n) - ww;
  img=img-min(img(:));
  img=img/max(img(:));
  imwrite(img,sprintf('imgsq%i.pgm',n));
  fd=fopen(sprintf('imgsq%i.pgm',n),'r+');
  fseek(fd,0,'bof');
  fprintf(fd,'P5\n256 256\n255\n');
  fclose(fd);
end

for n=2:N
  fprintf(1,'intragof: analyzing image %i/%i...\r',n,N);
  unix(sprintf('gof ./ %i -M 0 -noimgs -nowarp -int -minlev 0',n));
  unix('rm -f v1* v2* v3*');
end

fprintf(1,'intragof: combining results...                 \r');
combiflow('v0.f%i.m0.short','gof.mat',N);

fprintf(1,'intragof: integrating displacements...         \r');
[dx,dy] = ofseq('gof.mat',2,N);

fprintf(1,'intragof: all done.                          \n');

unix('rm -f v0*');
unix('rm -f gof.mat');

cd(here);
