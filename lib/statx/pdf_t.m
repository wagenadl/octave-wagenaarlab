function pp = pdf_t(tt,df)
% PDF_T - Probability density function for Student's t distribution
%   pp = PDF_T(tt,df) returns the pdf for the t distribution
%   with DF degrees of freedom.

pp = gamma((df+1)/2) ./ ...
    (sqrt(df*pi)*gamma(df/2) .* (1+(tt.^2/df)).^((df+1)/2));

