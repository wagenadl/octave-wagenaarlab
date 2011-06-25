function [pairs1,pairs2] = matchevents(p1,mu1,sigma1, p2,mu2,sigma2)
% [pairs1,pairs2] = matchevents(p1,mu1,sigma1, p2,mu2,sigma2) finds 
% matching events in the two event sets specified (from FINDPEAKS).
% For every event in p1, pairs1 will contain the index from p2 with 
% which it was paired, or 0 if there was no matching event in p2.
% Likewise, for every event in p2, pairs2 will contain the index
% from p1 with which it was paired, or 0. Note that pairs1 and
% pairs2 contain equivalent information.
%
% This function was written for the analysis of the Sept/Oct '01
% Phoenix experiments. See notes dd 10/8/01 in red notebook. Note that
% this implementation does not reject pairs if they are too loose. 
% Such pruning can be performed very easily based on the return values
% of this function though.
%
% Warning: when comparing more than two blocks, there is no
% guarantee that the pairwise matches returned by this function are 
% consistent, that is, if (k1,k2) is a pair between blocks 1 and 2
% and (k2,k3) is a pair between blocks 2 and 3, there is no
% guarantee that (k1,k3) is a pair between blocks 1 and 3. I think
% that it is entirely possible for there to be a pair (k1,l3)
% between 1 and 3, or even for k1 not to match anything in block 3.
% 
% For the Phoenix data set, this implies that each block should be
% compared to baseline, and not to the surrounding blocks.

% Measure the size of the data: K_i=events in set i
	K1=length(p1);
	K2=length(p2);

% Inialize output
	pairs1=zeros(K1);
	pairs2=zeros(K2);

% Sort by peak times
        [mu1 idx1]=sort(mu1);
	p1=p1(idx1);
	sigma1=sigma1(idx1);

        [mu2 idx2]=sort(mu2);
	p2=p2(idx2);
	sigma2=sigma2(idx2);
	
% Loop over p1, trying to find matches (despite appearances, p1 and 
% p2 are treated symmetrically by this algorithm).
        for k1=1:K1
% Find previous and next peak on p2 - if there is an exact match,
% prev and next are the same. That's OK.
	  nextk2=min(find(mu2>=mu1(k1)));
	  prevk2=max(find(mu2<=mu1(k1)));
% Find any peak on p1 that lies between us and the next and prevs,
% and find out which of the two peaks is nearer.
	  nextk1=k1;
	  dnext=inf;
	  if ~isempty(nextk2)
	    nextk1=max(find(mu1<=mu2(nextk2)))
	    dnext=mu2(nextk2)-mu1(k1);
	  end
	    
	  prevk1=k1;
	  dprev=inf;
	  if ~isempty(prevk2)
	    prevk1=min(find(mu1>=mu2(prevk2)))
	    dprev=mu1(k1)-mu2(prevk2);
	  end
	  if dprev<dnext
	    if prevk1==k1
% If previous is closer, and there's nothing between the two of us:
              pairs1(k1)=prevk2;
	      pairs2(prevk2)=k1;
	    end
	  else
	    if nextk1==k1
% If next is closer, and there's nothing between the two of us:
              pairs1(k1)=nextk2;
	      pairs2(nextk2)=k1;
	    end
	  end
	end

	
	    
