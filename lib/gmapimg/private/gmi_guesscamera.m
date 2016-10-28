function cam = gmi_guesscamera(rois, dv)
  ncams = length(unique(rois.cam));
  if ncams==1
    % Only one camera
    x = sort(abs(rois.x));
    dx = mean(x(1:ceil(N/2)).^2);
    if dx < 0.275
      % ventral
      if strcmp(dv, 'ventral')
        cam = 1;
      else
        cam = [];
      end
    else
      if strcmp(dv, 'dorsal')
        cam = 1;
      else
        cam = [];
      end
    end
  elseif ncams==2
    r1 = mtc_normalizecoords(subset(rois, rois.cam==1));
    r2 = mtc_normalizecoords(subset(rois, rois.cam==2));
    x1 = sort(abs(r1.x));
    x2 = sort(abs(r2.x));
    dx1 = mean(x1(1:ceil(length(x1)/2)).^2);
    dx2 = mean(x2(1:ceil(length(x2)/2)).^2);
    if strcmp(dv, 'dorsal')
      cam = 1 + (dx2>dx1);
    elseif strcmp(dv, 'ventral')
      cam = 1 + (dx2<dx1);
    else
      cam = [];
    end
  else
    cam = [];
  end
end

  