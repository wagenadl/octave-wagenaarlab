function aperw = pda36a_sensitivity(wvl)
% PDA36A_SENSITIVITY - Sensitivity of the Thorlabs PDA36A detector
%    AperW = PDA36A_sensitivity(wavelength) returns the sensitivity
%    of the Thorlabs PDA36A detector (in amperes per watt of light) 
%    at the given wavelength (in nanometers).
%    WAVELENGTH should be in the range 350 to 1100.

tbl = [
  350 0.045
360 0.045
370 0.046
380 0.048
390 0.054
400 0.062
410 0.071
420 0.081
430 0.092
440 0.103
450 0.114
460 0.124
470 0.135
480 0.146
490 0.156
500 0.166
510 0.177
520 0.188
530 0.199
540 0.21
550 0.22
560 0.232
570 0.242
580 0.253
590 0.263
600 0.275
610 0.287
620 0.299
630 0.312
640 0.323
650 0.335
660 0.346
670 0.358
680 0.369
690 0.38
700 0.389
710 0.401
720 0.414
730 0.424
740 0.435
750 0.447
760 0.458
770 0.467
780 0.478
790 0.488
800 0.499
810 0.51
820 0.52
830 0.53
840 0.538
850 0.547
860 0.555
870 0.565
880 0.573
890 0.582
900 0.589
910 0.599
920 0.606
930 0.611
940 0.619
950 0.624
960 0.631
970 0.634
980 0.637
990 0.633
1000 0.624
1010 0.606
1020 0.574
1030 0.532
1040 0.473
1050 0.404
1060 0.329
1070 0.264
1080 0.216
1090 0.175
1100 0.14];

if wvl>=350 && wvl<=1100
  aperw = interp1(tbl(:,1), tbl(:,2), wvl, 'linear');
else
  error('The PDA36A has no defined sensitivity at the wavelength requested');
end

