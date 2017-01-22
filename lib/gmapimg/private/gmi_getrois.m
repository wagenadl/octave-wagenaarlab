function rois = gmi_getrois(x)
% GMI_GETROIS - Extract ROIs from VSCOPE data for gmapimg
% Empty ROIs get assigned a NAN camera
R = length(x.rois);
rois.x = zeros(R,1) + nan;
rois.y = zeros(R,1) + nan;
rois.rx = zeros(R,1) + nan;
rois.ry = zeros(R,1) + nan;
rois.cam = zeros(R,1) + nan;
for r=1:R
  if ~isempty(x.rois{r})
    rois.x(r) = mean(x.rois{r}(:,1));
    rois.y(r) = mean(x.rois{r}(:,2));
    rois.rx(r) = std(x.rois{r}(:,1))*sqrt(2);
    rois.ry(r) = std(x.rois{r}(:,2))*sqrt(2);
    rois.cam(r) = find(strcmp(x.roicams{r}{1}, x.ccd.info.camid));
  end
end
rois.r = sqrt(rois.rx.^2 + rois.ry.^2) / sqrt(2);
rois.y = 512-rois.y;
