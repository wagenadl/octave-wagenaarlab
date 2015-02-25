function qcrisppdf

svgfn = qsave('svg');
pdffn = strrep(svgfn, 'svg', 'pdf');
if unix(sprintf('crispsvg2pdf %s %s', svgfn, pdffn))
  error('Failed');
end

  
