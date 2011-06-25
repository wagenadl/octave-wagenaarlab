function hw=cr2hw(cr)
% hw = CR2HW(cr) converts row and column to hardware channel number.
% cr count from 11 to 88;
% hw counts from 0.
% illegal c,r values return -1.
r=mod(cr,10);
c=floor(cr/10);
if (c<1 | c>8 | r<1 | r>8)
    hw=-1;
  return;
end

mp = [ 60, 20, 18, 15, 14, 11, 9, 62, -1, -1, 23, 21, 19, 16, 13, 10, ...
      8, 6, -1, -1, 25, 24, 22, 17, 12, 7, 5, 4, -1, -1, 28, 29, 27, ...
      26, 3, 2, 0, 1, -1, -1, 31, 30, 32, 33, 56, 57, 59, 58, -1, -1, ...
      34, 35, 37, 42, 47, 52, 54, 55, -1, -1, 36, 38, 40, 43, 46, 49, ...
      51, 53, -1, -1, 61, 39, 41, 44, 45, 48, 50, 63, -1, -1 ];
hw=mp(10*(c-1)+r);

