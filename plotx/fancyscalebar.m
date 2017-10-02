function fbh = fancyscalebar(loc,coord,edges,txt)
% FANCYSCALEBAR - Fancy scale bars
%   FANCYSCALEBAR(loc,coord,edges,txt) adds a new scale bar to the current
%   axes.
%   h = FANCYSCALEBAR(...) returns handles as per FANCYBAR.
%
%   Example:
%
%      h = FANCYSCALEBAR('x',-0.5,[4 5],'1 s');
%      set(h.axis,'linew',1);
%
%   This places a horizontal scale bar of length 1 from x=4 to x=5 at
%   y=-0.5 with the text "1 s" below it.

fbh = fancybar(loc,coord,{[],edges},[],{txt});
