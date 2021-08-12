tks= myls(['Database audio']);

% Initialize the hash table database array

clear_hashtable

% Calculate the landmark hashes for each reference track and store
% it in the array (takes a few seconds per track).

add_tracks(tks);

srt = 44100;

r = audiorecorder(srt, 16, 1);

%P is amount of time before each fingerprint loop

P = 20;

t = 0;

Length = 120;

disp('3')
pause(1)
disp('2')
pause(1)
disp('1')
pause(1)

while t < Length


%clear R and dt data to restart audio variable
% clear R
clear dt

disp('recording')
record(r)
pause(P)
dt = getaudiodata(r);
stop(r);
disp('Stopped')
% Load a query waveform (recorded from playback on a laptop)

%% 

% Run the query

R = match_query(dt,srt);

% R returns all the matches, sorted by match quality.  Each row
% describes a match with three numbers: the index of the item in
% the database that matches, the number of matching hash landmarks,
% and the time offset (in 32ms steps) between the beggining of the
% reference track and the beggining of the query audio.

%If there are no hits return no hits, if there are less than 10 hits
%display hits under threshold, if there are over 10 hits match to the audio

if isempty(R) == 1
    disp('No Hits')
elseif R(1,2) < 5
    disp('Hits do not reach threshold')
    
else
     R(1,:)
    illustrate_match(dt,srt,tks);
    colormap(1-gray)
end

t = t + P;
end