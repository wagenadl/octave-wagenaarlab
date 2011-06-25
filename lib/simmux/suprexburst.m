function ss=suprexburst(mm,big)
%if nargin<4 | isempty(t0) | isempty(t1)
%  t0=min(mm.onset);
%  t1=max(mm.offset);
%  dt=t1-t0;
%  t0=t0-dt/length(mm.onset);
%  t1=t1+dt/length(mm.onset);
%end
bss = simplexburst(mm.qonset(big),0*mm.qonset(big),10,2,10,7,10);

ss.onset = bss.onset;
S=length(ss.onset);
ss.constit=cell(S,1);
ss.offset = bss.offset;
for s=1:S
  ss.constit{s} = find(mm.qonset>=bss.onset(s) & mm.qonset<=bss.offset(s));
  ss.onset(s) = min(mm.gonset(ss.constit{s}));
  ss.offset(s) = max(mm.goffset(ss.constit{s}));
end
