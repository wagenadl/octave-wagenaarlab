function nn = tracer_applyfn(fn, wavelength)
for k = 1:length(fn)
  nn(k) = fn{k}(wavelength);
end
