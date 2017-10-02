function plot_mog(y,X)
% PLOT_MOG(y,X) plots the MoG results in y. Use y=em_mog(X,K) to
% fill y. The plot is a projection onto the first two axes.

K = length(y.p);

displ(X,K,y.mu,y.sig); % see below
%return;
disp(y.p);
disp(y.mu);
sigs = zeros(size(y.mu,1),0);
for k=1:K
  sigs = cat(2,sigs, y.sig{k});
end
disp(sigs);
fprintf(1,'Press enter to continue...\n');
pause;
return;

function displ(X,K,mu,sig)
% DISPL(X,K,mu,sig) is a helper function for plot_mog to
% plot the distribution.
% X: DxN
% K: 1x1
% mu: DxK
% sig: K cells of DxD


plot(X(1,:),X(2,:),'b.');
hold on;
for k=1:K
  s = sig{k};
  circ = gaussian_ellipse(mu(1:2,k),s(1:2,1:2),200);
  plot(circ(:,1),circ(:,2),'g');
%  plotGauss(mu(1,k),mu(2,k),s(1,1),s(2,2),s(1,2));
end
hold off;
drawnow;
return;