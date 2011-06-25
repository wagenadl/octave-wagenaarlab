function shp = extractshape(ctxt,gwid,shft)
% shp = EXTRACTSHAPE(ctxt, gwid) extracts important shape parameters from 
% the spike waveforms CTXT (TxN), based on Gaussians of width GWID:
%
% shp(1,:) = intg Gaus * ctxt
% shp(2,:) = intg Gaus * |ctxt|^2
% shp(3,:) = intg Gaus * (dctxt / dt)
% shp(4,:) = intg Gaus * |dctxt / dt|^2

if nargin<3
  shft=[];
end

[T,N]=size(ctxt);
shp = zeros(4,N);

if length(gwid)==1
  gwid=repmat(gwid,4,1);
else
  gwid=gwid(:);
end

if isempty(shft)
  tt = [1:T]; tt=tt-mean(tt);
  gaus = exp(-.5*(tt/gwid(1)).^2);
  gaus = gaus ./ sqrt(sum(gaus.^2));
  shp(1,:) = gaus * ctxt;
  
  gaus = exp(-.5*(tt/gwid(2)).^2);
  gaus = gaus ./ sqrt(sum(gaus.^2));
  shp(2,:) = gaus * ctxt.^2;
  
  tt = [2:T]; tt=tt-mean(tt);
  gaus = exp(-.5*(tt/gwid(3)).^2);
  gaus = gaus ./ sqrt(sum(gaus.^2));
  shp(3,:) = gaus * diff(ctxt);
  
  gaus = exp(-.5*(tt/gwid(4)).^2);
  gaus = gaus ./ sqrt(sum(gaus.^2));
  shp(4,:) = gaus * diff(ctxt).^2;
else
  tt = [1:T]; tt=tt-mean(tt)+shft(1);
  gaus = exp(-.5*(tt/gwid(1)).^2);
  gaus = gaus ./ sqrt(sum(gaus.^2));
  shp(1,:) = gaus * ctxt;
  
  tt = [1:T]; tt=tt-mean(tt)+shft(2);
  gaus = exp(-.5*(tt/gwid(2)).^2);
  gaus = gaus ./ sqrt(sum(gaus.^2));
  shp(2,:) = gaus * ctxt;
  
  tt = [1:T]; tt=tt-mean(tt)+shft(3);
  gaus = exp(-.5*(tt/gwid(3)).^2);
  gaus = gaus ./ sqrt(sum(gaus.^2));
  shp(3,:) = gaus * ctxt;
  
  tt = [2:T]; tt=tt-mean(tt)+shft(4);
  gaus = exp(-.5*(tt/gwid(4)).^2);
  gaus = gaus ./ sqrt(sum(gaus.^2));
  shp(4,:) = gaus * diff(ctxt).^2;
end