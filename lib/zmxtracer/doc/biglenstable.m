function biglenstable
files = readdir('lenses');
F = length(files);

qfigure('/tmp/biglenses', 10, 10);
qmarker o solid 3
qalign left middle

typs = [];
logf = [];

for f=1:F
  if ~endswith(files{f},'.m')
    continue;
  end
  fn = files{f}(1:end-2);
  try
    lens = eval(fn);
    if median(lens.diam) < 28
      continue;
    end
    [x, f] = tracer_pplane(lens);
  catch
    fprintf(1, 'Could not find f for %s: %s\n', fn, lasterror.message);
    continue
  end
  if f<0
    continue;
  end
  
  txt = tolower(help(fn));
  if strfind(txt,'dw')
    continue;
  end
  if strfind(txt,'achromat')
    if strfind(txt, 'pair')
      typ = 8;
    else
      typ = 6;
    end
  elseif strfind(txt, 'aspher')
    typ = 10;
  elseif strfind(txt, 'meniscus')
    typ = 5;
  elseif strfind(txt, 'best')
    typ = 2;
  elseif strfind(txt, 'convex')
    if strfind(txt, 'plano')
      typ = 3;
    else
      typ = 1;
    end
  else
    typ = 12;
  end
  
  while any(typs==typ & abs((logf-log(f)).^2)<.002)
    typ = typ + 1;
  end
  
  typs = [typs typ];
  logf = [logf log(f)];
  
  qmark(typ, log(f));
  qat(typ, log(f));
  qtext(3, 0, fn);
  qtext(8, 11, sprintf('/%.0f/', median(lens.diam)));
end

lbl = strtoks('Biconvex Bestform Planoconvex ~ Meniscus Achromat ~ A.pair ~ Asphere ~');
L = length(lbl);
for l=1:L
  qat(l, log(1100));
  qtext(0, 0, lbl{l});
end

for x = [.9 2.9 4.9 7.9 9.9]
  qticklen 8
  if x==0.9 || x==2.9 || x==9.9
    qyaxis(x, log([10 15 20:10:50 100 150 200:100:500 1000]), [10 15 20:10:50 100 150 200:100:500 1000], '/f/ (mm)');
  else
    qyaxis(x, log([10 15 20:10:50 100 150 200:100:500 1000]), []);
  end   
  qticklen 5
  qyaxis(x, log([10:10:90 200:100:900]), {});
  qticklen 2
  qyaxis(x, log([11:19 22:2:38 110:10:190 220:20:380]), {});
end
qat(4.5, log(1250))
qfont Helvetica bold 12
qtext(0, 0, 'Positive lenses with > 1” diameter');

qshrink 1
qsave biglenstable.pdf
