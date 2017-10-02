function yy = salpa(xx,varargin)
% SALPA - Suppression of Artifacts by Local Polynomial Approximation
%   This is the algorithm described in Wagenaar & Potter, 2002. 
%   yy = SALPA(xx) runs SALPA with default arguments.
%   yy = SALPA(xx, key1,val1, ...) specifies options:
%
%     tau          - half width of filter window (default: 30 samples)
%     threshold    - threshold for depegging (default: inf)
%     rails [2x1]  - sample values for pegging (default: [-inf inf])
%     t_blankdepeg - number of samples before depeg (default: 5)
%     t_ahead      - number of samples to look ahead (default: 5)
%     t_chi2       - number of samples for quality test (default: 15)

kw=getopt('tau=30 threshold rails t_blankdepeg=5 t_ahead=5 t_chi2=15',varargin);
if isempty(kw.threshold)
  kw.threshold=inf;
end
if isempty(kw.rails)
  kw.rails=[-inf inf];
end

opts = double([kw.rails(:)' kw.threshold kw.tau kw.t_blankdepeg kw.t_ahead kw.t_chi2]);

if length(opts)~=7
  error('SALPA: Bad options');
end

yy = salpamex(xx,opts);
