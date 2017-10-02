function [x,y] = hw2jn90(hw)
% HW2JN - Convert MCS hardware channel number to JN-MEA location at 90 deg
%   [x,y] = HW2JN(hw) where HW is between 0 and 63 returns XY positions
%   for the requested electrodes, assuming that the MEA had its "missing"
%   electrode pointed toward the "85" edge rather than the "47" edge of the 
%   amplifier.
%   The A1,A2,A3,D? channels are still in the NW,NE,SW,SE corners.

% MEA hardware order starts at CR 47 and goes clockwise up to CR 57.
% So if the array has notch to 85, that means that the physical CR47 electrode
% is recorded on the channel normally used for CR85, which is hw45 rather
% than hw0.
% In other words, hw45 in the file is the electrode normally associated with
% hw0.

idx = find(hw<60); % don't process aux electrodes
hw(idx) = hw(idx) - 45; % convert 45 to 0
hw(hw<0) = hw(hw<0) + 60; % of course, it's all mod 60.

[x_, y_] = hw2jn(hw);

x = 8-y_;
y = x_;

x(hw==60)=0; y(hw==60)=16;
x(hw==61)=8; y(hw==61)=16;
x(hw==62)=0; y(hw==62)=0;
x(hw==63)=8; y(hw==63)=0;
