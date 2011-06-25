function spk = ss_oversampledoutliers(spk)
% SS_OVERSAMPLEDOUTLIERS - SS_OUTLIERS for oversampled data
%   spk = SS_OVERSAMPLEDOUTLIERS(spk) is just like SS_OUTLIERS, except
%   that it operates on downsampled waveforms. This is good if SPK contains
%   oversampled waveforms, because kmeans commonly and for unknown reasons
%   complains that
%        "matrix is close to singular or badly scaled.
%        Results may be inaccurate,"
%   when run on oversampled data. This function extracts the oversampling
%   factor from the data, so is extremely easy to use.

F = spk.Fs / spk.Fs0;
sp.waveforms = spk.waveforms(:,1:F:end);
sp.spiketimes = spk.spiketimes;
sp.Fs = spk.Fs0;
sp.threshT = (spk.threshT-1)/F + 1;
sp.threshV = spk.threshV;

% Detect outliers
sp = ss_outliers(sp);

% Remove outliers
spk.outliers = sp.outliers;
spk.outliers.waveforms = spk.waveforms(sp.outliers.badinds, :);
spk.waveforms = spk.waveforms(sp.outliers.goodinds, :);
spk.spiketimes = spk.spiketimes(sp.outliers.goodinds);
