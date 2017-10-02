function testtau(tau)
T8=0;
for t=-tau:tau
  T8 = T8 + t.^8;
end
maxint = 2^63;

fprintf(1,'Testtau: tau=%.0f T8=%.4e maxint=%.4e\n',tau,T8,maxint);
