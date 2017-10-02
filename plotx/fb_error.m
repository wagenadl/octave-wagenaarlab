function fb_error(str)
% FB_ERROR - For internal use by FANCYBAR only
if nargin<1
  error('FANCYBAR: Incorrect arguments.');
else
  error('FANCYBAR: %s.',str);
end

