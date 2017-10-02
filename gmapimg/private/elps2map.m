function elps2map(elpsfn, svginfn, svgoutfn, facecol, edgecol, widths)

K = size(facecol, 1);
if nargin<5
  edgecol = facecol;
end
if nargin<6
  widths = zeros(K, 1);
end

svg = {};
fd = fopen(svginfn, 'r');
if fd<0
  error('cannot read svginfn');
end

while 1
  txt = fgets(fd);
  if ischar(txt)
    svg{end+1} = txt;
  else
    break;
  end
end
fclose(fd);


svgwid = 2350;
for n=1:length(svg)
  [s,e,te,m,t,nm,sp] = regexp(svg{n}, 'width="(\d+)"');
  if ~isempty(t)
    svgwid = atoi(t{1}{1});
  end
end

elps = textread(elpsfn, '');

fd = fopen(svgoutfn, 'w');
for n=1:length(svg)
  fputs(fd, svg{n});
  if ~isempty(strfind(svg{n}, 'ELLIPSES')
    for q=1:size(elps, 1)
      k = elps(q,1);
      x = elps(q,2);
      y = elps(q,3);
      R = elps(q,4);
      r = elps(q,5);
      a = elps(q,6);
      R1 = R.^.7 * r.^.3;
      r1 = R.^.3 * r.^.7;
      fprintf(fd, '<ellipse transform="translate(%.1f,%.1f) rotate(%.1f)"\n', x,y,a);
      fprintf(fd, ' rx="%.1f" ry="%.1f"\n', R1, r1);
      fprintf(fd, ' fill="%s" stroke="%s" stroke-width="%.1f"/>\n', hexcolor(facecol(k,:)), hexcolor(edgecol(k,:)), widths(k));
    end
  end
end
fclose(fd);

function rgb = hexcolor(rgb)
rgb = sprintf('#%02x%02x%02x', floor(rgb*255.9));
