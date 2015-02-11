function est = mea_estrms(rawdata, W, frc)
% MEA_ESTRMS - Estimate RMS noise in MEABench raw data
%    est = MEA_ESTRMS(rawdata, W, frc) splits the RAWDATA 
%    (CxT = channels x scans) into windows of length W scans and calculates 
%    the standard deviation of the signal in each.
%    It then returns the FRC-th quantile of the std.devs.
%    FRC may be a vector of length K, in which case the return value is of
%    size CxK.
%    To convert the result into a proper noise estimate, you need to multiply
%    by a constant derived by passing pure Gaussian data into MEA_ESTRMS.

[C,T] = size(rawdata);
W = round(W);
N = floor(T/W);
rawdata = reshape(rawdata(:,N*W),[C W N]);
rms = std(rawdata,1,2);

idx = ceil(frc*N);
est = squeeze(rms(:,1,idx));
