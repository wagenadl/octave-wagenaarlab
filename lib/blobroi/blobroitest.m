function blobroitest
dat=vsdload('/home/wagenaar/vsddata/090211/019.xml');
img = dat.ccd.dat(:,:,1);
figure(1); clf
set(1,'position',[800 100 1024 1024]);
set(1,'position',[480 20 768 768]);
axes('position',[0 0 1 1]);
h=imagesc(img);
colormap(gray);
phi=[0:256]'*2*pi/256;
blobs{1}=[cos(phi)*20+135 sin(phi)*20+292];
blobs=cell(0,0);
setappdata(gcf,'blob_phi',phi);
setappdata(gcf,'blob_blobs',blobs);
setappdata(gcf,'blob_idx',0);
setappdata(gcf,'blob_outline_hh',[]);
setappdata(gcf,'blob_axes_h',gca);
blobroi_redraw;
set(gcf,'windowbuttondownfcn',@blobroi_click);
set(gcf,'windowbuttonup',@blobroi_unclick);
