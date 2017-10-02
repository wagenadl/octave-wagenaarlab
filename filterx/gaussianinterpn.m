function yy = gaussianinterpn(xx, dat_x, dat_y, smo_x)
% yy_o = GAUSSIANINTERPN(xx_o, xx_i, yy_i, smo_x) produces a smooth
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
% This implementation does not assume data is 1D. XX_O and XX_I must be
% NxD. SMO_X may be a scalar or a length-D vector. YY_I must be Nx1.
[N D]=size(xx);
if prod(size(smo_x))==1
  smo_x = repmat(smo_x,[1 D]);
end

yy=zeros(N,1);
for n=1:N
  fprintf(1,'gaussianinterpn %i/%i\r',n,N);
  wei = ones(N,1);
  for d=1:D
    wei = wei .* exp(-.5*(dat_x(:,d)-xx(n,d)).^2./smo_x(d).^2);
  end
  yy(n) = sum(dat_y.*wei) ./ sum(wei);
end
