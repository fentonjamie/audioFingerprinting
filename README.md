# audioFingerprinting

This code runs an audio fingerprinting algorithm taken from Robust Landmark-Based Audio Fingerprinting which more detail can be found here: https://www.ee.columbia.edu/~dpwe/resources/matlab/fingerprint/

This code had not manipulated this algorithm and all the functions in this project relate to the fingerprinting algorithm.

The idea of this project is to continually monitor the output from a media device orchestration project. It does this by recording the sound scape and matching it's fingerprint to a fingerprint of audio in the data base. If the database contains audio files of each variation of the soundscape with different objects or aux devices missing the algorithm should be able to match to which file shows the correct soundscape at that time therefore knowing if an object or device has gone missing. 

This code was run in MATLAB 2020b.

To operate this code first place the database audio you wish to use in the "Database Audio" folder as well as in the main MATLAB directory.

Then open the fingerprint_Loop.m MATLAB script. The only variables that should need to change are P the amount of time you wish the audio to record for the fingerprint. And L the length of time of the media device project you're monitoring. Once running MATLAB will display which file in the database the fingerprint matched with. This will be number referring to which file in the database, it will also display the number of hashes which corresponds with how strong the match was. I will give more detail to each aspect of the code below. 

% First create the varible tks loading the information from the database audio files

tks= myls(['Database audio']);

% Clear any data from the last fingerprint

clear_hashtable

% Add these tracks to the database using the add_tracks function and set the sample rate of the audio in this case 44.1 Hz

add_tracks(tks);
srt = 44100;

%Create a recorder object r in MATLAB

r = audiorecorder(srt, 16, 1);

% P sets the amount of time between each fingerprint, this essentially is the fingerprint resolution, also set a time variable t to keep track of how much time has passed. Also set the total amount of length L of the devicve orchestration project you are monitoring. 

P = 20;

t = 0;

Length = 120;

% Puase and display so that the playing of the orchestration project can be timed with the start of the fingerprinting (Probably need to find a better way to do this!)

disp('3')
pause(1)
disp('2')
pause(1)
disp('1')
pause(1)

% this is the main loop of the script. While the current time is less than the total length this will run. This will continually display the results from the fingerprinting checking

while t < Length


%clear R and dt data to restart audio variable
% clear R
clear dt

disp('recording')
% record the audio coming into the microphone or laptop and keep recording for time P

record(r)
pause(P)

% get audio data into a two collumn array named variable dt
dt = getaudiodata(r);

% Stop recording 
stop(r);
disp('Stopped')
% Load a query waveform (recorded from playback on a laptop)


% This is the function which matches the audio we've recorded dt with the audio in the database 

R = match_query(dt,srt);

% R returns all the matches, sorted by match quality.  Each row
% describes a match with three numbers: the index of the item in
% the database that matches, the number of matching hash landmarks,
% and the time offset (in 32ms steps) between the beggining of the
% reference track and the beggining of the query audio.

%If there are no hits return no hits, if there are less than 10 hits
%display hits under threshold, if there are over 5 hits match to the audio

if isempty(R) == 1
    disp('No Hits')
elseif R(1,2) < 5
    disp('Hits do not reach threshold')
    
    % if there is a match display the match on a spectrogram
    
else
     R(1,:)
    illustrate_match(dt,srt,tks);
    colormap(1-gray)
end

% add time to t and repeat loop 

t = t + P;
end
