function [seq,fs] = DTMFsequence(filename)

[signal,fs] = audioread(filename);

if(fs < 3000)
    error('Sampling rate is too low');
end

newsignal = signal';
t = (0:length(newsignal)-1).*(1/fs);
figure(1)
plot(t, newsignal);
title("Time Signal for " + filename);
xlabel('Time (sec)');
ylabel('Amplitude');

%Use bandpass filter and remove values that don't match key tones
bandfilter = bandpass(signal,[690 1480],fs);
noiseremoved = (bandfilter > 0.06 | bandfilter < max(bandfilter)*-0.06).*bandfilter;
t1 = (0:length(noiseremoved)-1).*(1/fs);
figure(2)
plot(t1,noiseremoved)
title("Time Signal w/ Noise Removed for " + filename);
xlabel('Time (sec)');
ylabel('Amplitude');

%store sequence with removed noise into indices
sequence = find(noiseremoved);
signallength = length(sequence);

%store initial value of sequence
keypresses = [sequence(1)];

%Look any signficant differences in amplitude between each
%sequence value. If the difference is greater than 100, then store in
%array.
j = 2;
for i = 2:signallength
    if ((sequence(i) - sequence(i-1)) > 100)
        keypresses(j) = sequence(i-1);
        keypresses(j+1) = sequence(i);
        j = j + 2;
    end
end

%Final value of the sequence is stored
keypresses(j) = sequence(signallength);

targetlength = length(keypresses);

finkeys = [];
x = 1;
y = 2;

%Similar method to DTMFdecode but we go through each key press
while(x <= targetlength)
    if ((keypresses(y) - keypresses(y-1)) > 500)
        shortsig = bandfilter(keypresses(x):keypresses(x+1));
        
        fouriersig = abs(fft(shortsig));
        fx = (0:length(fouriersig)-1)*(fs/length(fouriersig));
        fourierlen = length(fouriersig);
        
        halffourier = round((fourierlen-1)/2);
        [~,I] = maxk(fouriersig(1:(halffourier)),5);
        lowfreq = fx(min(I));
        highfreq = fx(max(I));
        
        lowkey = [697, 770, 852, 941];
        highkey = [1209, 1336, 1477];
        
        low = zeros(1,4);
        for i = 1:4
            low(i) = abs(lowkey(i) - lowfreq);
        end

        high = zeros(1,3);
        for i = 1:3
            high(i) = abs(highkey(i) - highfreq);
        end
        
        l = find(low == min(low));
        h = find(high == min(high));

        keys = ['1', '2', '3';
                '4', '5', '6';
                '7', '8', '9';
                '*', '0', '#'];
        key = keys(l,h);
        
        finkeys = [finkeys, key];
        
        x = x + 2;
        y = y + 2;
    else
        x = x + 2;
        y = y + 2;
    end
end

seq = finkeys;

end