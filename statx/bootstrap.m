function [m,s] = bootstrap(nboot, bootfun, varargin)
% [m,s] = BOOTSTRAP(NBOOT, BOOTFUN, ...) calculates the mean and std.dev.
% of bootstrap data samples taken from the function values of BOOTFUN on the
% dataset(s) formed by the third and later arguments. This function simply
% calls the matlab stats toolbox's BOOTSTRP function, which is reproduced
% below for convenience.
%
% It would be easy to modify this function to return a full variance matrix:
% Just change the line "s = std(st);" to "s = var(st);".

st = bootstrp(nboot,bootfun,varargin{:});
m = mean(st);
s = std(st);
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bootstat, bootsam] = bootstrp(nboot,bootfun,varargin)
%BOOTSTRP Bootstrap statistics.
%   BOOTSTRP(NBOOT,BOOTFUN,...) draws NBOOT bootstrap data samples and
%   analyzes them using the function, BOOTFUN. NBOOT must be a
%   positive integer. The third and later arguments are the data;
%   BOOTSTRP passes bootstrap samples of the data to BOOTFUN.
%
%   [BOOTSTAT,BOOTSAM] = BOOTSTRP(...) Each row of BOOTSTAT contains
%   the results of BOOTFUN on one bootstrap sample. If BOOTFUN
%   returns a matrix, then this output is converted to a long
%   vector for storage in BOOTSTAT. BOOTSAM is a matrix of indices
%   into the rows of the extra arguments.
%
%   Examples:
%   To produce a sample of 100 bootstrapped means of random samples
%   taken from the vector Y:
%      M = BOOTSTRP(100, 'mean', Y)
%
%   To produce a sample of 200 bootstrapped coefficient vectors for
%   a regression of the vector Y on the matrix X:
%      B = BOOTSTRP(200, 'regress', Y, X)
 
%   Reference:
%      Efron, Bradley, & Tibshirani, Robert, J.
%      "An Introduction to the Bootstrap",
%      Chapman and Hall, New York. 1993.
 
%   B.A. Jones 9-27-95, ZP You 8-13-98
%   Copyright 1993-2002 The MathWorks, Inc.
%   $Revision: 2.11 $  $Date: 2002/01/17 21:30:04 $
 
% Initialize matrix to identify scalar arguments to bootfun.
la = length(varargin);
scalard = zeros(la,1); db = cell(la,1);
 
% find out the size information in varargin.
n = 1;
for k = 1:la
   [row,col] = size(varargin{k});
   if max(row,col) == 1
      scalard(k) = 1;
   end
   if row == 1 & col ~= 1
      row = col;
      varargin{k} = varargin{k}(:);
   end
   n = max(n,row);
end
 
% Create index matrix of bootstrap samples.
bootsam = unidrnd(n,n,nboot);
 
% Get result of bootfun on actual data and find its size.
thetafit = feval(bootfun,varargin{:});
[ntheta ptheta] = size(thetafit);
 
% Initialize a matrix to contain the results of all the bootstrap calculations.
bootstat = zeros(nboot,ntheta*ptheta);
 
% Do bootfun - nboot times.
for bootiter = 1:nboot
   for k = 1:la
      if scalard(k) == 0
         db{k} = varargin{k}(bootsam(:,bootiter),:);
      else
         db{k} = varargin{k};
      end
   end
   tmp = feval(bootfun,db{:});
   bootstat(bootiter,:) = (tmp(:))';
 end
 return
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
function r = unidrnd(n,mm,nn)
%UNIDRND Random matrices from the discrete uniform distribution.
%   R = UNIDRND(N) returns a matrix of random numbers chosen
%   uniformly from the set {1, 2, 3, ... ,N}.
%
%   The size of R is the size of N. Alternatively,
%   R = UNIDRND(N,MM,NN) returns an MM by NN matrix.
 
%   Copyright 1993-2002 The MathWorks, Inc.
%   $Revision: 2.10 $  $Date: 2002/03/31 22:26:56 $
 
if nargin == 1
    [errorcode rows columns] = rndcheck(1,1,n);
elseif nargin == 2
    [errorcode rows columns] = rndcheck(2,1,n,mm);
elseif nargin == 3
    [errorcode rows columns] = rndcheck(3,1,n,mm,nn);
else
    error('Requires at least one input argument.');
end
 
if errorcode > 0
    error('Size information is inconsistent.');
end
 
r = ceil(n .* rand(rows,columns));
 
% Fill in elements corresponding to illegal parameter values
if prod(size(n)) > 1
    r(n < 0 | round(n) ~= n) = NaN;
elseif n < 0 | round(n) ~= n
    r(:) = NaN;
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [errorcode, rows, columns] = rndcheck(nargs,nparms,arg1,arg2,arg3,arg4,arg5)
%RNDCHECK error checks the argument list for the random number generators.
 
%   Copyright 1993-2002 The MathWorks, Inc.
%   $Revision: 2.10 $  $Date: 2002/03/31 22:26:57 $
 
sizeinfo = nargs - nparms;
errorcode = 0;
rows = [];
columns = [];
 
if sizeinfo == 0
    if nparms == 1
        [rows columns] = size(arg1);
    elseif nparms == 2
        scalararg1 = (prod(size(arg1)) == 1);
        scalararg2 = (prod(size(arg2)) == 1);
        if ~scalararg1 & ~scalararg2
            [r1 c1] = size(arg1);
            [r2 c2] = size(arg2);
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;
            end
        end
        if ~scalararg1
            [rows columns] = size(arg1);
        elseif ~scalararg2
            [rows columns] = size(arg2);
        else
            [rows columns] = size(arg1);
        end
    elseif nparms == 3
        [r1 c1] = size(arg1);
        [r2 c2] = size(arg2);
        [r3 c3] = size(arg3);
        scalararg1 = (prod(size(arg1)) == 1);
        scalararg2 = (prod(size(arg2)) == 1);
        scalararg3 = (prod(size(arg3)) == 1);
         
        if ~scalararg1 & ~scalararg2
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;
            end
        end
         
        if ~scalararg1 & ~scalararg3
            if r1 ~= r3 | c1 ~= c3
                errorcode = 1;
                return;
            end
        end
         
        if ~scalararg3 & ~scalararg2
            if r3 ~= r2 | c3 ~= c2
                errorcode = 1;
                return;
            end
        end
        if ~scalararg1
            [rows columns] = size(arg1);
        elseif ~scalararg2
            [rows columns] = size(arg2);
        else
            [rows columns] = size(arg3);
        end
    end
elseif sizeinfo == 1
    scalararg1 = (prod(size(arg1)) == 1);
    if nparms == 1
        if prod(size(arg2)) ~= 2
            errorcode = 2;
            return;
        end
        if  ~scalararg1 & arg2 ~= size(arg1)
            errorcode = 3;
            return;
        end
        if (arg2(1) < 0 | arg2(2) < 0 | arg2(1) ~= round(arg2(1)) | arg2(2) ~= round(arg2(2))),
            errorcode = 4;
            return;
        end
        rows    = arg2(1);
        columns = arg2(2);
    elseif nparms == 2
        [r1 c1] = size(arg1);
        [r2 c2] = size(arg2);
        if prod(size(arg3)) ~= 2
            errorcode = 2;
            return;
        end
        scalararg2 = (prod(size(arg2)) == 1);
        if ~scalararg1 & ~scalararg2
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;
            end
        end
        if (arg3(1) < 0 | arg3(2) < 0 | arg3(1) ~= round(arg3(1)) | arg3(2) ~= round(arg3(2))),
            errorcode = 4;
            return;
        end
        if ~scalararg1
            if any(arg3 ~= size(arg1))
                errorcode = 3;
                return;
            end
            [rows columns] = size(arg1);
        elseif ~scalararg2
            if any(arg3 ~= size(arg2))
                errorcode = 3;
                return;
            end
            [rows columns] = size(arg2);
        else
            rows    = arg3(1);
            columns = arg3(2);
        end
    elseif nparms == 3
        [r1 c1] = size(arg1);
        [r2 c2] = size(arg2);
        [r3 c3] = size(arg3);
        if prod(size(arg4)) ~= 2
            errorcode = 2;
            return;
        end
        scalararg1 = (prod(size(arg1)) == 1);
        scalararg2 = (prod(size(arg2)) == 1);
        scalararg3 = (prod(size(arg3)) == 1);
         
        if (arg4(1) < 0 | arg4(2) < 0 | arg4(1) ~= round(arg4(1)) | arg4(2) ~= round(arg4(2))),
            errorcode = 4;
            return;
        end
         
        if ~scalararg1 & ~scalararg2
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;
            end
        end
         
        if ~scalararg1 & ~scalararg3
            if r1 ~= r3 | c1 ~= c3
                errorcode = 1;
                return;
            end
        end
         
        if ~scalararg3 & ~scalararg2
            if r3 ~= r2 | c3 ~= c2
                errorcode = 1;
                return;
            end
        end
        if ~scalararg1
            if any(arg4 ~= size(arg1))
                errorcode = 3;
                return;
            end
            [rows columns] = size(arg1);
        elseif ~scalararg2
            if any(arg4 ~= size(arg2))
                errorcode = 3;
                return;
            end
            [rows columns] = size(arg2);
        elseif ~scalararg3
            if any(arg4 ~= size(arg3))
                errorcode = 3;
                return;
            end
            [rows columns] = size(arg3);
        else
            rows    = arg4(1);
            columns = arg4(2);
        end
    end
elseif sizeinfo == 2
    if nparms == 1
        scalararg1 = (prod(size(arg1)) == 1);
        if ~scalararg1
            [rows columns] = size(arg1);
            if rows ~= arg2 | columns ~= arg3
                errorcode = 3;
                return;
            end
        end
        if (arg2 < 0 | arg3 < 0 | arg2 ~= round(arg2) | arg3 ~= round(arg3)),
            errorcode = 4;
            return;
        end
        rows = arg2;
        columns = arg3;
    elseif nparms == 2
        [r1 c1] = size(arg1);
        [r2 c2] = size(arg2);
        scalararg1 = (prod(size(arg1)) == 1);
        scalararg2 = (prod(size(arg2)) == 1);
        if ~scalararg1 & ~scalararg2
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;
            end
        end
        if ~scalararg1
            [rows columns] = size(arg1);
            if rows ~= arg3 | columns ~= arg4
                errorcode = 3;
                return;
            end
        elseif ~scalararg2
            [rows columns] = size(arg2);
            if rows ~= arg3 | columns ~= arg4
                errorcode = 3;
                return;
            end
        else
            if (arg3 < 0 | arg4 < 0 | arg3 ~= round(arg3) | arg4 ~= round(arg4)),
                errorcode = 4;
                return;
            end
            rows = arg3;
            columns = arg4;
        end
    elseif nparms == 3
        [r1 c1] = size(arg1);
        [r2 c2] = size(arg2);
        [r3 c3] = size(arg3);
        scalararg1 = (prod(size(arg1)) == 1);
        scalararg2 = (prod(size(arg2)) == 1);
        scalararg3 = (prod(size(arg3)) == 1);
         
        if ~scalararg1 & ~scalararg2
            if r1 ~= r2 | c1 ~= c2
                errorcode = 1;
                return;
            end
        end
         
        if ~scalararg1 & ~scalararg3
            if r1 ~= r3 | c1 ~= c3
                errorcode = 1;
                return;
            end
        end
         
        if ~scalararg3 & ~scalararg2
            if r3 ~= r2 | c3 ~= c2
                errorcode = 1;
                return;
            end
        end
         
        if ~scalararg1
            [rows columns] = size(arg1);
            if rows ~= arg4 | columns ~= arg5
                errorcode = 3;
                return;
            end
        elseif ~scalararg2
            [rows columns] = size(arg2);
            if rows ~= arg4 | columns ~= arg5
                errorcode = 3;
                return;
            end
        elseif ~scalararg3
            [rows columns] = size(arg3);
            if rows ~= arg4 | columns ~= arg5
                errorcode = 3;
                return;
            end
        else
            if (arg4 < 0 | arg5 < 0 | arg4 ~= round(arg4) | arg5 ~= round(arg5)),
                errorcode = 4;
                return;
            end
            rows    = arg4;
            columns = arg5;
        end
    end
end
 
