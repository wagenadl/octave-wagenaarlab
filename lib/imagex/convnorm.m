function imo = convnorm(img, kernel)
% CONVNORM - Convolve with a kernel, normalizing at edges
%    img = CONVNORM(img, kernel) convolves the image IMG with the one-
%    dimensional kernel KERNEL. The non-singleton dimension of kernel 
%    determines which dimension of IMG we work on.
%    The convolution is normalized, even for image points near the edges.

S = size(img);
SK = size(kernel);
dim = find(SK>1);

if length(dim)>1
  error('CONVNORM: must have one-dimensional kernel');
elseif length(dim)==0
  return; % Trivial case
end

K = SK(dim);
L = S(dim);

if L<=K
  error('CONVNORM: The image must be larger than the kernel');
end
if mod(K,2)==0
  error('CONVNORM: The kernel must have odd length');
end

S0 = prod(S(1:dim-1));
S1 = prod(S(dim+1:end));

img = reshape(img, [S0 L S1]);
kernel = reshape(kernel,[1 K 1]);
kernel = kernel ./ sum(kernel);
imo = convn(img, kernel, 'same');

warning ("off", "Octave:broadcast", "local");

K0 = floor(K/2);
for k=1:K0
  kern = kernel(K0+2-k:K);
  kern = kern ./ sum(kern);
  a_ = img(:, 1:k+K0, :);
  imo(:,k,:) = sum(a_.*kern, 2);
end

for k=L-K0+1:L
  kern = kernel(1:L+1-k+K0);
  kern = kern ./ sum(kern);
  a_ = img(:, k-K0:L, :);
  imo(:,k,:) = sum(a_.*kern, 2);
end

imo = reshape(imo, S);

