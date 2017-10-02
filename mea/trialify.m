function [tms,tri]=trialify(spks,pre_ms,post_ms);
% [tms,tri] = TRIALIFY(spks,pre_ms,post_ms) returns latency and trial
% numbers for spikes SPKS loaded by LOADSPKS or LOADSPKSNOC.
% Resulting TMS will be in milliseconds. PRE_MS and POST_MS are
% window extents as per .desc file.

win_s = (pre_ms+post_ms)/1000;
tri = floor(spks.time/win_s);
tms = mod(spks.time - win_s*tri,win_s) * 1000 - pre_ms;
