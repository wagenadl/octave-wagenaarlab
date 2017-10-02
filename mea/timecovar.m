function cc=timecovar(t,l)
% cc=TIMECOVAR(t,l) returns the pairwise correlations between times 
% of instantiations of events. t,l must be from INSTANTIATEEVENTS.
% For each pair of events, only those trials are considered in
% which both event were instantiated 
%
% This function was written for the analysis of the Sept/Oct '01
% Phoenix experiments. See notes dd 10/8/01 in red notebook.
%
% See also: COOCCURRENCE.

% Measure the size of the data: T=trials, K=events
	T=size(l,2);
	K=size(l,1);

% Initialize output (trick: diags will be one after adding of transpose)
	cc=eye(K)/2;
	
% Loop over all pairs of events
	for k1=1:(K-1)
	  for k2=(k+1):K
% Find trials with instantiation of both...
	    idx=find(l(k1,:)~=0 & l(k2,:)~=0);
	    tmp=t([k1,k2],idx);
% ... and compute correlation if possible
            if isempty(tmp)
	      cc(k1,k2)=nan;
	    else
	      cc(k1,k2)=corrcoef(tmp');
	    end
	  end
	end
% Complete the other triangle of the matrix by adding transpose:
        cc=cc+cc';
	
