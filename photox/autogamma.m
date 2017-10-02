function gamma = autogamma(vals,target)
% gamma = AUTOGAMMA(vals,target) returns the gamma value that would 
% normalize VALS to have mean=target.
[yyy,xxx] = hist(vals,[0:.01:1]);
yyy=yyy/sum(yyy);
gamma = fminsearch(@foo,1,[],xxx,yyy,target);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function err = foo(gamma,xxx,yyy,target)
err = (sum(xxx.^gamma.*yyy) - target).^2;
