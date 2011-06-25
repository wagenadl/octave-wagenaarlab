function [bst, bsam] = dbootstrap(N,fun,varargin)
% DBOOTSTRAP - Calculate bootstrap statistics
%    bst = DBOOTSTRAP(n,fun,x) calculates bootstrap statistics by calling
%    the function FUN with subsamples from X. This is done N times, and
%    the results are returned as an Nx1 vector if FUN returns scalar results.
%    X is sliced into rows, that is, X must be Kx1, KxA, KxAxB, etc, where
%    K is the number of data points.
%    FUN may return 1xD results, in which case BST will be NxD.
%    bst = DBOOTSTRAP(n,fun,x,y,...) feeds extra arguments into FUN.
%    [bst,bsam] = DBOOTSTRAP(...) additionally returns a NxK array indicating
%    which values were used for each call.

A=length(varargin);
SS=cell(A,1);
isScalar=zeros(A,1);
for a=1:A
  SS{a} = size(varargin{a});
  isScalar(a) = prod(SS{a})==1;
end
x=varargin{1};
S=size(x); 
K=S(1);
if nargout>=2
  bsam = zeros(N,K);
end

arg=cell(A,1);
for a=1:A
  arg{a}=varargin{a};
end

y = feval(fun,arg{:});
Sy=size(y);
if Sy(1)>1
  if Sy(2)==1
    Sy(2)=Sy(1);
    Sy(1)=1;
  else
    Sy=[1 Sy];
  end
end
bst=zeros([N Sy(2:end)]);

for n=1:N
  sam=ceil(rand(K,1)*K);
  if nargout>=2
    bsam(n,:)=sam';
  end
  for a=1:A
    if ~isScalar(a)
      ar=reshape(varargin{a},[K prod(SS{a}(2:end))]);
      arg{a} = reshape(ar(sam,:),[SS{a}]);
    end
  end
  bs=feval(fun,arg{:});
  bst(n,:) = reshape(bs,Sy);
end
