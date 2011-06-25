function y = nextntrode(x, E)
% NEXTNTRODE - Returns the next ordered n-trode 
%    y = NEXTNTRODE(x, E), where X is a vector specifying an n-trode, and
%    E is the total number of electrodes, returns the next n-trode in the 
%    standard ordering.
%    NEXTNTRODE without arguments gives a demo.

if nargin==0
  % Demo mode
  trode=[0 1 2 3];
  trodes=[];
  for k=1:100
    trodes=[trodes; trode];
    fprintf(1,'%i ', trode); 
    fprintf(1,'\n'); 
    trode=nextntrode(trode, 10); 
  end
  y = trodes;
  return
end


trode = x;
trode = nextntrode_core(int32(trode), int32(E));
y = double(trode);
