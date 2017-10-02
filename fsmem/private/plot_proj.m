function plot_proj(X,R,proj)
% PLOT_PROJ(X,R,projs) plots a projection of the data X,
% which are clustered according to the responsibilities R. Points
% are given different colors, based on the largest responsibility.
% Input: X: DxN data
%        R: NxK responsibilities
%        proj: Dx2 projection matrix

%whos

x = proj' * X; % 2xN
[ r, idx ] = max(R,[],2);
K = size(R,2);
oldhold = ishold;
for k=1:K
  si = find(idx==k);
  sx = x(:,si); % 2xdN
  cols = 'rgbcym';
  typs = '+o.x';
  col = cols(mod(k,6)+1);
  typ = typs(mod(floor(k/6),4)+1);
  plot(sx(1,:),sx(2,:),strcat(col,typ));
  hold on;
end
if (oldhold == 0)
  hold off;
end
