function proj = rnd_proj(Din,Dout)
% proj = RND_PROJ(Din,Dout) produces a random projection from Din
% dimensions down to Dout. The projection is constrained so that 
% each input coordinate axes is always projected parallel to an 
% output axis, and such that the input axes are evenly spread about
% the output axes, for as far as that is possible.
% Input: Din: integer
%        Dout: integer
% Output: Din x Dout matrix (with unnormalized columns)
% Typical use: generate projection to 2D for plot_proj.

rnge = eye(Dout);
plenty = repmat(rnge,[Din 1]);
proto = plenty(1:Din,:);

% Uncomment for normalization:
% for d = 1:Dout
%   proto(:,d) = proto(:,d) / norm(proto(:,d));
% end

rndm = rand(1,length(proto));
[ dummy, idx ] = sort(rndm);
proj = proto(idx,:);
