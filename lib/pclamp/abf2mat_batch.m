function abf2mat_batch( dirname, step, recurse )
% abf2mat_batch( dirname, step, recurse )
%
% for each .abf file in a directory,
% converts Axon binary format file to a sequence of MAT-files,
% each of which contains STEP samples from the .abf file [default 1e7]
%
% requires import_abf()
% only works correctly for gap-free recordings
%
% if RECURSE is 1, then acts recursively on all subdirectories
% [default 0]
%
% JAB 6/26/07

if nargin < 3, recurse = 0; end
olddir = pwd;

cd( dirname )
d = dir;
for ff = 1:length( d )
    % recurse in subdirectories, if applicable
    if d(ff).isdir & recurse
        fprintf( 1, 'recursing in %s\n', d(ff).name )
        abf2mat_batch( [d(ff).name], recurse )
    end
    % act on all ABF files in current directory
    if ~d(ff).isdir & strcmp( d(ff).name(end-3:end), '.abf' )
        fprintf( 1, 'working on %s\n', d(ff).name )
        if nargin < 2, abf2mat( d(ff).name )
        else, abf2mat( d(ff).name, step ), end
    end
end

cd( olddir )
