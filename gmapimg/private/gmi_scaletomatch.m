function xf = gmi_scaletomatch(xf, res, tgt, sep)
% GMI_SCALETOMATCH - Scale uniformly or x-y to match variance
cvtx = var(tgt.x, 1);
cvty = var(tgt.y, 1);
cv0x = var(res.x, 1);
cv0y = var(res.y, 1);
if nargin>=4 && sep
  xf = af_scale(xf, sqrt(cvtx./cv0x), sqrt(cvty./cv0y));
else
  scl = sqrt((cvtx + cvty) / (cv0x + cv0y));
  xf = af_scale(xf, scl);
end

