function h = elplot_xyabc(el,npts,varargin)
% ELPLOT_XYABC  Plot an ellipse defined by covariances.
%    ELPLOT_XYABC(el,npts) plots an ellipse defined by its center,
%    and covariances.
%    EL must be a structure with fields: x0, y0, alpha, beta, gamma.
%    The ellipse is defined as:
%
%                  2               2
%      alpha (x-x0)  +  beta (y-y0)  +  2 gamma (x-x0) (y-y0) = 1
%
%    NPTS specifies the number of points to plot per quarter of the 
%    ellipse; default is 16.
%    ELPLOT_XYABC(el,npts,key1,val1,...) specifies additional plot options.
%    h = ELPLOT_XYABC(...) returns a plot handle.


% Since alpha X^2 + beta Y^2 + 2 gamma XY = 1, we can solve:
%                                     2 2                   2
%        - 2 gamma X  +-  sqrt(4 gamma X  -  4 beta (alpha X - 1 ) ) 
%   Y = ------------------------------------------------------------ ,
%                                 2 beta                             
%                                                       2   2
%         - gamma X  +-  sqrt(beta - (alpha beta - gamma ) X ) 
%     = ------------------------------------------------------- .
%                                   beta                     
%
% Thus, the extremes are: X = +- beta / (alpha beta - gamma^2).

if nargin<2
  npts=16;
end

A = el.alpha*el.beta-el.gamma^2;
rng = [-npts:npts]/npts;
xx = rng*sqrt(el.beta/A);
D = el.beta*(1-rng.^2);
yyp = (-el.gamma*xx + sqrt(D)) / el.beta;
yym = (-el.gamma*xx - sqrt(D)) / el.beta;
h = plot([xx fliplr(xx)] + el.x0,...
    [yyp fliplr(yym)] + el.y0,varargin{:});

if nargout<1
  clear h
end

