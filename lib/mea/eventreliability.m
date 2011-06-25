function r=eventreliability(ll)
% r=EVENTRELIABILITY(ll) returns a matrix of observed reliabilities 
% of events for several blocks of experiments. Sorry for the vague
% explanation. Here's the details: ll must be a cell vector with each
% cell corresponding to an experimental block, e.g. a treatment, or
% a stimulus voltage value. The contents of these cells are KxT
% likelihood values returned by instantiateevents. The output
% r(b,k) will contain the fraction of trials where the event k is
% instantiated in block b, as measured by the fraction of non-zero
% ll values.
% Requirements: the number of events must be the same in every
% block, but the number of trials per block may vary. 
% (MATCHEVENTS may be used to find pairs of co-occurring events in
% different blocks.)
%
% This function was written for the analysis of the Sept/Oct '01
% Phoenix experiments. See notes dd 10/8/01 in red notebook.
% 
% Note for hackers: ll is only tested for equality to zero. Thus,
% hh can be passed instead of ll without any change in output.

% Measure the size of the data: B=blocks, K=events
	B=length(ll);
	K=size(ll{1},1);
	
% Initialize output
	r=zeros(B,K);

% Loop over blocks in search of the reliabilities
	for b=1:B
% Find number of trials
	  T=size(ll{b},2);
% Mark all non-zero likelihoods
	  tmp=reshape(ll{b},[K*T 1]);
	  tmp(find(tmp))=1;
	  tmp=reshape(tmp,[K T]);
% Add them all up (per event)
	  r(b,:) = sum(tmp') / T;
	end
	
