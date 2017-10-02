function savecsv(ofn, varargin)
% SAVECSV - Saves several vectors to a CSV file
%    SAVECSV(filename, x, y, ...) creates a CSV file from the 
%    variables X, Y, ..., with default column labels.
%    More usefully, SAVECSV(filename, 'x', 'y', ...) creates a CSV file
%    with column labels generated from the variable names.
%    SAVECSV(filename, 'labelx', x, 'labely', y, ...) specifies labels
%    and contents directly.
%    Each of the variables _must_ be either an Nx1 cell array of strings or
%    an Nx1 vector of numbers. All vectors must be the same length.
%    Note that by Octave's function call rules, you can quite conveniently
%    say
%      SAVECSV filename.csv x y
%    to save the variables "x" and "y."
%    A major use case for this function is to export data to R, which can read
%    the results straight into a dataframe using "read.csv('filename.csv')."
%    A final way to use SAVECSV is like
%      SAVECSV(filename, vlabel, dimlabels, variable),
%    where VLABEL must be a single string, VARIABLE a multidimensional matrix,
%    and DIMLABELS a space-separated list of names for each of the dimensions
%    of the matrix.

if nargin<2
  error('SAVECSV needs a filename and something to save');
end

if nargin==4 && ischar(varargin{1}) && ischar(varargin{2}) ...
          && isnumeric(varargin{3})
  vlabel = varargin{1};
  dimlabels = strtoks(varargin{2});
  var = varargin{3};
  S = size(var);
  K = length(dimlabels);
  if length(S) ~= K
    error('SAVECSV must have match between labels and data');
  end
  args = cell(2*K + 2, 1);
  args{1} = vlabel;
  var = var(:);
  ok = find(~isnan(var));
  args{2} = var(ok);
  for k=1:K
    nn = [1:S(k)];
    dim = 0*S + 1;
    dim(k) = S(k);
    nn = reshape(nn, dim);
    rep = S;
    rep(k) = 1;
    nn = repmat(nn, rep);
    nn = nn(:);
    args{2*k + 1} = dimlabels{k};
    args{2*k + 2} = nn(ok);
  end
  savecsv(ofn, args{:});
  return
end
  
if nargin==2 && isstruct(varargin{1})
  lbls = fieldnames(varargin{1});
  N = length(lbls);
  args = cell(2*N, 1);
  for n=1:N
    args{2*n-1} = lbls{n};
    args{2*n} = varargin{1}.(lbls{n});
  end
  savecsv(ofn, args{:});
  return;
end

labels = {};
data = {};
paired = 0;
if mod(nargin, 2)==1
  % Possibly paired
  K = floor(nargin/2);
  paired = 1;
  for k=1:K
    if ischar(varargin{2*k-1}) && isnumeric(varargin{2*k})
      % paired
    else
      paired = 0;
    end
  end
end

if paired
  K = floor(nargin/2);
  for k=1:K
    labels{k} = varargin{2*k-1};
    data{k} = varargin{2*k};
  end
else
  K = nargin-1;
  anystring = 0;
  anynumber = 0;
  for k=1:K
    if ischar(varargin{k})
      anystring = 1;
    else
      anynumber = 1;
    end
  end
  if anynumber && anystring
    error('SAVECSV cannot accept mixed named and anonymous vectors');
  end
  if anystring
    for k=1:K
      labels{k} = varargin{k};
      data{k} = evalin('caller', varargin{k});
    end
  else
    for k=1:K
      labels{k} = sprintf('X%i', k);
      data{k} = varargin{k};
    end
  end
end

% So now we have labels and data, but we have to check that data all are
% same length
N = length(data{1});
for k=1:K
  if length(data{k})~=N || length(data{k})~=numel(data{k})
    error('SAVECSV needs vectors of same length');
  end
end

for k=1:K
  if iscell(data{k})
    for n=1:N
      if ~ischar(data{k}{n})
	error('SAVECSV needs numeric vectors or cell vectors containing strings');
      end
    end
  end
end

% All good. Let's write stuff
fd = fopen(ofn, 'w');
if fd<0
  error(sprintf('SAVECSV could not write to "%s"\n', ofn));
end
unwind_protect
seps = '';
for k=1:K-1
  seps(k) = ',';
end
seps(K) = "\n";

for k=1:K
  fprintf(fd, '"%s"%s', labels{k}, seps(k));
end

for n=1:N
  for k=1:K
    if iscell(data{k})
      fprintf(fd, '"%s"%s', data{k}{n}, seps(k));
    else
      fprintf(fd, '%g%s', data{k}(n), seps(k));
    end
  end
end

unwind_protect_cleanup

fclose(fd);

end


    