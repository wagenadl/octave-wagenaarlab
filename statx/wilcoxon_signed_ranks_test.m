function [p1,p2] = wilcoxon_signed_ranks_test(a,b)
% [p1,p2] = WILCOXON_SIGNED_RANKS_TEST(a,b)
% Returns one-tailed test for H0: A does not exceed B, as well as two-tailed 
% test for H0: A equals B.
% That is, if A>>B, we will get P1 close to zero and P2=2*P1. If A<<B,
% we will get P1>=0.5 and P2 close to zero; if A~=B, we get P1>=0.5 and
% P2>=0.5.
% For small N, this uses table lookup, and P1 is reported as 1 if P1 would
% be >0.05, while P2 is reported as 1 if P2 would be >0.10. For large N,
% normal approximation is used, and P1 and P2 are "exact".
%
% The table is taken from a website. I would be better off taking it from Zar instead.
[Tplus,Tmin,nsr] = wilcoxon_signed_ranks(a,b);

if nsr<5
  p1=1; p2=1;
elseif nsr<.29
  % Following table obtained from "Statistical data analysis", 
  % by Dr. Dang Quang A and Dr. Bui The Hong
  % Institute of Information Technology
  % Hoang Quoc Viet road, Cau giay, HANOI. 
  % http://www.netnam.vn/unescocourse/statistics/13_4.htm
  tbl0 = [
    0.05 0.1 1 2 4 6 8 11
    0.025 0.05 nan  1 2 4 6 8
    .01 0.02  nan nan   0 2 3 5
    .005 0.01  nan nan nan   0 2 3
    nan 0.1 14 17 21 26 30 36
    .025 0.05 11 14 17 21 25 30
    0.01 0.02 7 10 13 16 20 24
    .005 0.01 5 7 10 13 16 19
    nan .1 41 47 54 60 68 75
    .025 0.05 35 40 46 52 59 66
    .01 0.02 28 33 38 43 49 56
    .005 0.01 23 28 32 37 43 49
    nan .1 83 92 101 110 120 130
    .025 0.05 73 81 90 98 107 117
    .01 0.02 62 69 77 85 93 102
    .005 .01 55 61 68 76 84 92
    ];
  tbl0=reshape(tbl0,[4 4 8]);
  pp1 = repmat(tbl0(:,:,1),[1 1 6]); 
  pp2 = repmat(tbl0(:,:,2),[1 1 6]);
  vals = tbl0(:,:,3:8);
  pp1 = reshape(permute(pp1,[3 2 1]),[24 4]);
  pp2 = reshape(permute(pp2,[3 2 1]),[24 4]);
  vals = reshape(permute(vals,[3 2 1]),[24 4]); 
  % Use one-tailed test
  T=Tmin;
  tbl = vals(nsr-4,:);
  pp = [1 pp1(nsr-4,:)];
  idx=findlast_ge(tbl,T);
  p1=pp(idx+1);
  % Use two-tailed test
  T=min(Tmin,Tplus);
  tbl = vals(nsr-4,:);
  pp = [1 pp2(nsr-4,:)];
  idx=findlast_ge(tbl,T);
  p2=pp(idx+1);
else
  % Gaussian approx OK
  z = (Tplus - nsr*(nsr+1)/4) / sqrt(nsr*(nsr+.5)*(2*nsr+1)/24);
  % need invnorm!
  %normtable
  %pp=[1 pp];
  %idx=findlast_le(xx1,-z);
  %p1=pp(idx+1);
  %idx=findlast_le(xx2,abs(z));
  %p2=pp(idx+1);
  p1 = cdf_norm(-z);
  p2 = 2*cdf_norm(-abs(z));
end
