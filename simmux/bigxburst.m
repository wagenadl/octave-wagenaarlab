function kk=bigxburst(mm,fracmin)
% kk=BIGXBURST(mm,fracmin) returns the indices of "big"
% bursts in the given set of multix bursts.
% "Big" means at least FRACMIN as many participating channels as the
% largest burst.
% Alternatively, if FRACMIN>1, it represents the minimum number of 
% channels in absolute terms.
% MM must be the return of MULTIXBURST.

% Copyright (C) 2004  Daniel Wagenaar (wagenaar@caltech.edu)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


if nargin<2 | isempty(fracmin)
  fracmin=.5;
end
%if nargin<3 | isempty(samplemin)
%  samplemin=3;
%end


%ccnt = sum(mm.cmap>0,1);
%nactive=sum(ccnt>=samplemin);
if fracmin<=1
  nactive = max(sum(mm.cmap>0,2));
  fracmin=floor(fracmin*nactive);
end
kk=find(mm.cc>=fracmin);

