%read in the babble noise to use for the function
[noise, fs] = audioread('babble.wav');
noise = noise';


% Generates a random number 1-10, used to simulate sequences of varying
% length
randlength = round(9 * rand(1, 1) + 1);
randseq = round(12 .*rand(1, randlength))
% numbers 10 and 11 represent '*' and '#' respectively

signal = [];

%random duration between 0.1 and 0.5 second
duration = 0.4*rand(1, 1)+0.1;

%random weight for each key
weight = [(rand(1, 1)+1) ((rand(1, 1)+1))];

%random amount of space ranging between 1600 and 3200 between each key
%press
%z = zeros(1, round(1600 * rand(1, 1) + 1600));
%encoding each key press
 for i = 1:length(randseq)
     x = DTMFencode2(num2str(randseq(i)),duration,weight);
     z = zeros(1, round(3200 * rand(1, 1) + 1600));
     signal = [signal z x];
 end
 
 
 %make normalized noise equal to the length of the normalized signal
 noiseshortened = noise(1:length(signal));
 
 %normalize both the noise and signal to an absolute maximum of 1
 normsignal = normalize(signal,'range');
 normnoise = normalize(noiseshortened,'range');
 
 
error = zeros(1,31);
j = 1;
original = DTMFsequence2(normsignal)
for a = 0:0.1:3
    y = normsignal + a.*normnoise;
    combined = DTMFsequence2(y);
    
    if strcmp(combined,original)
        error(j) = 1;
    end
    j = j+1;
end
 