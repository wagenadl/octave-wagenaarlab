function tpi = gearcalc(tri, sq, num, let, gear1, gear2)
% GEARCALC - Gear calculations for inch threads on Jet BDB-1340 lathe
%   tpi = GEARCALC(tri, sq, num, let) calculates the TPI obtained
%   on the Jet BDB-1340 lathe when using:
%      circle (TRI=0) or triangle (TRI=1)
%      pentagram (SQ=0) or square (SQ=1)
%      number given by NUM
%      letter given by LET
%   and standard 32/48 gears.
%   Any of TRI, SQ, NUM, LET may be matrices of any size.
%   tpi = GEARCALC(tri, sq, num, let, gear1, gear2) performs the
%   calculations for other gear combinations.
%   Available gears are: 32, 33, 44, 46, 48 (two copies), 52.
%
%   Example: 1 / gearcalc(0, 1, 4, 'E', 44, 48) return 0.035012, 
%   which is the closest I can get to Thorlabs SM thread using inch 
%   wheels.
%
%   To get mm threads, calculate 25.4 * (120/127) / gearcalc(...).
%
%   Example: (120/127) / gearcalc(0, 1, 4, 'E', 32, 33) returns 0.034996,
%   which is even better.
%
%   See also FINDGEARS.

if nargin<5
  gear1 = 32;
end
if nargin<6
  gear2 = 48;
end

if ischar(let)
  let = toupper(let)+1-'A';
end

tpi = 4 * (gear2 ./ gear1) / (3/2);
tpi = tpi .* (1 + 1*(tri>0));
tpi = tpi .* (1 + 3*(sq>0));

fac62 = 3/2;
fac61 = 10/9;
fac52 = 8/7;
fac24 = 12/11;
fac6 = [fac61 fac62 nan fac62*fac24 fac62/fac52 1];
tpi = tpi .* fac6(num);

facdb = 8/7;
facdc = 22/21;
facde = 9/5.25;
facea = 40/36;
facb = [facea*facde/facdb 1 facdc/facdb 1/facdb facde/facdb];
tpi = tpi .* facb(let);
  
