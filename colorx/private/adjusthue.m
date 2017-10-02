function ll = adjusthue(ll, l0, dl, sc)
dL = 1 - sc*exp(-((ll-l0)/dl).^2);
ll = cumsum(dL); 
ll = 360*ll/ll(end);
ll = ll - ll(find(ll>=l0, 1));
ll = ll + l0;
ll = mod(ll, 360);
