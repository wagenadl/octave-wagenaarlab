function btri = burststimid(bursts,tritime)
% btri =  BURSTSTIMID(bursts,tritime) finds the trial number that most 
% closely precedes the bursts in BURSTS. 
% BURSTS must be the result of GLOBALBURST or its friends. The only field
%        actually used is "onset".
% TRITIME must be a vector of times.

B=length(bursts.onset);
btri=zeros(1,B);
for b=1:B
  idx = find(tritime<bursts.onset(b));
  if ~isempty(idx)
    btri(b) = idx(end);
  end
end
