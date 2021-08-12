function [ IR ] = deconvolve( inv_filter, recording)
% DECONVOLVE Calculates the impulse response of a system by convolving the recorded output 
% with the inverse filter  corresponding to the excitation signal
%(already produced and saved in Inv_filter.mat)

% add some code here to read in the .wav file of a recorded sine wave sweep
% make sure to check the sampling rate is the same as the original sweep
% (called Sweep_20to20000_44100_pad3s.wav in the folder) 

    % Find out how many channels there are in the recording
    channels = min(size(recording));

    % Ensure we're dealing with columnar recorded data
    if channels ~= size(recording,2)      
        recording = recording';
    end
    
    % Ensure we're dealing with columnar filter data
    if size(inv_filter,2) > size(inv_filter,1)
        inv_filter = inv_filter';
    end
    
    % Create filter data with the right number of channels
    inv_filter = repmat(inv_filter(:,1),1,channels);

    % Perform deconvolution
    N = length(recording) + length(inv_filter)-1;
    IR = ifft( (fft(recording,N)).*fft(inv_filter,N));

    % Normalise across all channels
    IR = IR/max(max(abs(IR)));
    
    % Trim the data (remove silence equal to the sweep - or filter - length)
    IR = IR( length(inv_filter)+1:end,:);

end

