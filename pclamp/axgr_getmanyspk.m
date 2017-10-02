function axgr_getmanyspk(fnbase,fnout)
% AXGR_GETMANYSPK(fnbase) converts many macabf files to matlab format,
% extracting spike waveforms using axgr_getspk with standard params.

if nargin<2
  fnout=fnbase;
end

fail=0;
for a=1:999
  fn = sprintf('%s_%03i',fnbase,a);
  if exist(fn)
    fprintf(1,'Working on "%s"...\n',fn);
    [spk,ctx] = axgr_getspk(fn);
    spk.ctx = ctx;
    spk.shp = axgr_extractshape(ctx,[15 15 15 45],[0 -25 +25 0]);
    fn = sprintf('%s-%03i.mat',fnout,a);
    fprintf(1,'Saving "%s"...\n',fn);
    save(fn,'spk','-v6');
    fail=0;
  else
    fprintf(1,'No file "%s"...\n',fn);
    fail=fail+1;
    if fail>=10
      break;
    end
  end
end

