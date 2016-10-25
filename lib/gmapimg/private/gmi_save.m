function gmi_save(f, fname)
global cd_data

if nargin<2
  [fname,fpath,fltidx] = uiputfile('*.mat', 'Export match results');
  if ~ischar(fname) || isempty(fname)
    return
  end
  if ~endswith(fname, '.mat')
    fname = [fname '.mat'];
  end
  fname = [fpath filesep fname];
end

ifn = cd_data{f}.ifn;
can = cd_data{f}.can;
cres = cd_data{f}.cres;
act = cd_data{f}.act;
img = cd_data{f}.img;
arealabel = cd_data{f}.arealabel;

fprintf(1,'Saving into "%s"...\n', fname);
save(fname, 'ifn', 'can', 'cres', 'act', 'img', 'arealabel');
