function nnn=qoxset(nnn,bbb)
nnn.qonset=nnn.onset; 
nnn.qoffset=nnn.offset; 
N=length(nnn.onset);
for n=1:N
  bidx=nnn.constit{n};
  bon=bbb.onset(bidx);
  bof=bbb.offset(bidx);
  son=sort(bon);
  sof=sort(bof);
  L=max(length(son),2);
  nnn.qonset(n) = son(ceil(.25*L));
  nnn.qoffset(n) = sof(floor(.75*L));
end
