function rois = gmi_getrois(x)
R = length(x.rois);
rois.x = zeros(R,1);
rois.y = zeros(R,1);
rois.rx = zeros(R,1);
rois.ry = zeros(R,1);
rois.cam = zeros(R,1);
for r=1:R
  rois.x(r) = mean(x.rois{r}(:,1));
  rois.y(r) = mean(x.rois{r}(:,2));
  rois.rx(r) = std(x.rois{r}(:,1))*sqrt(2);
  rois.ry(r) = std(x.rois{r}(:,2))*sqrt(2);
  rois.cam(r) = find(strcmp(x.roicams{r}{1}, x.ccd.info.camid));
end
rois.r = sqrt(rois.rx.^2 + rois.ry.^2) / sqrt(2);
rois.y = 512-rois.y;
