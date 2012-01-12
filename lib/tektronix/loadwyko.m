function [dat, str] = loadwyko(ifn)
% LOADWYKO - Load Wyko interferometry data
%    dat = LOADWYKO(ifn) where IFN is the name of a WYKO ".asc" file, loads
%    the interferometry data contained in that file and returns the height
%    data converted to nanometers.
%    [dat, str] = LOADWYKO(ifn) also returns each of the header fields
%    in an information structure. Some may be more useful than others.

fd = fopen(ifn, 'r');
if fd<0
  error([ 'Cannot open: ' ifn ]);
end

str = struct;
while ~feof(fd)
  txt = fgetl(fd);
  if ~isempty(strfind(txt,'RAW_DATA'))
    break;
  end
  fld = strtoks(txt,'\t');
  key = fld{1};
  val = fld{end};
  key(key<=32)='_';
  num = str2double(val);
  if isnan(num)
    str.(key) = val;
  else
    str.(key) = num;
  end
end

dat = zeros(str.Y_Size,str.X_Size);
Bad=nan;
for x=1:str.X_Size
  txt = fgetl(fd);
  q=eval([ '[' txt ']' ]);
  dat(:,x)=q(:);
end

fclose(fd);

str.x_um_per_pix = str.XYR_x_spac*1e3;
str.y_um_per_pix = str.XYR_x_spac*1e3*str.Aspect;
str.Y_um = str.Y_Size*str.y_um_per_pix;
str.X_um = str.X_Size*str.x_um_per_pix;

dat = dat * str.Wavelength;

fld = strtoks('Ra Rp Rq Rt Rv Rz');
for q=1:length(fld)
  if isfield(str, fld{q})
    str.([fld{q} '_nm']) = str.(fld{q}) * str.Wavelength;
  end
end


