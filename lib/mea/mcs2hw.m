function hw = mcs2hw(mcs)
% MCS2HW - Convert MCRack "raw" channel number to MEABench "hardware" channel
%    hw = MCS2HW(mcs), where MCS is a "raw" channel number (1..60), returns
%    the corresponding "hardware" channel number (0..59). MCS may be a matrix.
%
%    Note that MEABench "hardware" channels are in order (C,R): (4,7), (4, 8),
%    (4, 6), ..., (5, 7). (Columns and rows are numbered 1..8).
%    By contrast, MCRack "raw" channels are in order (C,R): (2,1), (3,1), ...
%    (7,8).

cr = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 ...
83 14 24 34 44 54 64 74 84 15 25 35 45 55 65 75 85 16 26 36 46 56 66 ...
76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78 ];

hw = cr2hw(cr(mcs));
