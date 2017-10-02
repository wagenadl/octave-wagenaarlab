function xf = gmi_rotatetomatch(xf, res, tgt)
% GMI_ROTATETOMATCH - Rotate in complex space
ctgt = tgt.x + i*tgt.y;
cact = res.x + i*res.y;
dphi = (ctgt./abs(ctgt)) ./ (cact./abs(cact));
wei = abs(ctgt);
dphi = sum(dphi.*wei) ./ sum(wei);
dphi
xf = af_rotate(xf, arg(dphi));
