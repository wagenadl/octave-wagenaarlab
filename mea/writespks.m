function writespks(y,fid)
% WRITESPKS(y,fid) performs the opposite action to READSPKS.

hei=y.height * 2048/341;
wid=y.width * 25;
tms=floor(y.time*25000);
ti0=mod(tms,65536); idx=find(ti0>=32768); ti0(idx)=ti0(idx)-65536;
tms=floor(tms/65536);
ti1=mod(tms,65536); idx=find(ti1>=32768); ti1(idx)=ti1(idx)-65536;
tms=floor(tms/65536);
ti2=mod(tms,65536); idx=find(ti2>=32768); ti2(idx)=ti2(idx)-65536;
tms=floor(tms/65536);
ti3=mod(tms,65536); idx=find(ti3>=32768); ti3(idx)=ti3(idx)-65536;
raw = [ti0; ti1; ti2; ti3; y.channel; hei; wid; y.context; zeros(16,length(hei)); y.thr];
fwrite(fid,raw,'int16');
