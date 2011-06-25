function yy = gaussianinterp(xx, dat_x, dat_y, smo_x)
% yy = GAUSSIANINTERP(xx, dat_x, dat_y, smo_x) produces a smooth
% interpolation of the data: y(x) is estimated from all data points, 
% weighing them based on their distance to x.
%                                                      
%                             2      2                 
%                 -1/2 (x - x)  / smo                  
%         sum y  e       i                             
%          i   i                                       
% y(x) = ------------------------------                
%                            2      2                  
%                -1/2 (x - x)  / smo                   
%         sum   e       i                              
%          i                                           
%                                                      
% Current implementation assumes data is 1D.
N=length(xx);
yy=zeros(size(xx));
for n=1:N
  wei = exp(-.5*(dat_x-xx(n)).^2./smo_x.^2);
  yy(n) = sum(dat_y.*wei) ./ sum(wei);
end
