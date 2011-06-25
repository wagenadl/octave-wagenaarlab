function y=rolecluster(sxcspk)
% y=ROLECLUSTER(sxcspk) returns a cell matrix of role
% clusters based on the spikes in SXCSPK, which must have been
% produced by sxcl-invert.
% Output is in the form:
% y{CR}{role}.w0 - centroid width
%            .h0 - centroid height
%            .ww - width variance
%            .hh - height variance
%            .wh - width x height covariance
%            .n  - number of spikes in role
% Roles are numbered from 3 upwards, i.e. shifted by 3 from the
% input file.
% y{CR}{2} is the non-role (-1 in the input file).
% y{CR}{1} contains the w0,h0,ww,hh,wh,n statistics for all spikes on
% the channel combined. The output is in uV and ms.
% Recall that input columns are:
% Time_s ch_hw height_digi width_sams role_or_-1 rolemask

for hw=0:59
  cr=hw2crd(hw)
  hwidx=find(sxcspk(:,2)==hw);
  hwspks=sxcspk(hwidx,3:5);
  % hwspks columns are: 1=hei 2=wid 3=role
  hwspks(:,1)=hwspks(:,1) .* (341/2048);
  hwspks(:,2)=hwspks(:,2) ./ 25;
  maxrole = max(hwspks(:,3));
  for r=-1:maxrole
    roleidx=find(hwspks(:,3)==r);
    n=length(roleidx);
    if n>0
      rolespks=hwspks(roleidx,1:2);
      % rolespks columns are: 1=hei 2=wid
      y{cr}{r+3}.w0 = mean(rolespks(:,2));
      y{cr}{r+3}.h0 = mean(rolespks(:,1));
      if n>1
	cc=cov(rolespks);
      else
	cc=zeros(2,2); % hmmm.
      end
      y{cr}{r+3}.ww = cc(2,2);
      y{cr}{r+3}.hh = cc(1,1);
      y{cr}{r+3}.wh = cc(1,2);
      y{cr}{r+3}.n = n;
    else
      fprintf(1,'hw %i role %i is empty\n',hw,r);
      y{cr}{r+3}.w0=0;
      y{cr}{r+3}.h0=0;
      y{cr}{r+3}.ww=0;
      y{cr}{r+3}.hh=0;
      y{cr}{r+3}.wh=0;
      y{cr}{r+3}.n=0;
    end
  end
  y{cr}{1}.w0=mean(hwspks(:,2));
  y{cr}{1}.h0=mean(hwspks(:,1));
  cc=cov(hwspks(:,1:2));
  y{cr}{1}.ww=cc(2,2);
  y{cr}{1}.hh=cc(1,1);
  y{cr}{1}.wh=cc(1,2);
  y{cr}{1}.n=length(hwspks);
end
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a faulty implementation of hw2crd, I can't be bothered to 
% ppp the real vsn home right now.
%function cr=hw2crd(hw) 
%cr=hw+1;
%return
