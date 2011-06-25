function cc=cooccurrence(l)
% cc=COOCCURRENCE(l) returns the pairwise correlations between
% occurrences of events in l (from INSTANTIATEEVENTS).
%
% This function was written for the analysis of the Sept/Oct '01
% Phoenix experiments. See notes dd 10/8/01 in red notebook.
%
% See also: TIMECOVAR.

% Measure the size of the data: T=trials, K=events
	T=size(l,2);
	K=size(l,1);

% Mark all non-zero likelihoods
	tmp=reshape(l,[K*T 1]);
	tmp(find(tmp))=1;
	tmp=reshape(tmp,[K T]);

% Compute correlations
	cc=corrcoef(tmp');
	
% I wonder if this really is the most sensible measure of co-occurrence?
