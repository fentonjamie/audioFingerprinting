[background,Fs] = audioread('Main Recording.wav');

if Fs ~= srt
    disp('Sampling rates must be the same for phase inversion')
end

dtLow = lowpass(dt, 4000, srt, 'steepness', 0.8);
background = lowpass(background, 4000, srt, 'steepness', 0.8);

dtNorm = dtLow;


plot(dtNorm)
hold on
plot(dtLow, 'r')
hold off

[backgroundA,dtB,D] = alignsignals(background, dtNorm);


if max(size(backgroundA)) > max(size(dtB))
    backgroundA = backgroundA(1:max(size(dtB)));
else 
    dtB = dtB(1:max(size(backgroundA)));
end

inverted = backgroundA.*-1;

gains = 0:0.001:5;

meanGain = zeros(length(gains), 1);

for i = 1:length(gains)
    phased = inverted.*gains(i) + dtB;
    meanGain(i) = rms(phased);
end

% for i = 1:length(gains)
%     phased = inverted.*gains(i) + dtB;
%     meanGain(i) = sum(phased == 0);
% end

[gainLevel, idx] = min(abs(meanGain));

% [gainLevel, idx] = max(meanGain);

gain = gains(idx)

phaseInversed = dtB + inverted.*gain;

%median doesn't work might need to use rms

plot(inverted.*gain, 'b')
hold on
plot(dtB, 'r')
plot(phaseInversed, 'k')
hold off
