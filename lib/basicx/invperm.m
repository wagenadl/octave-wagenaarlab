function y=invperm(x)
% INVPERM  Inverse permutation of a vector of numbers
%    y = INVPERM(x), where X is a permutation of [1:N], returns the
%    inverse permutation, i.e. the vector Y s.t. y(x) = x(y) = [1:N].
y=zeros(size(x));
y(x) = [1:length(x)];
