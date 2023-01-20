function [key,fs] = DTMFdecode(filename)

if nargin == 0
    error('Invalid Filename')
end

%extract the signal in time domain and the sampling rate
[signal, fs] = audioread(filename);

if(fs < 3000)
    error('Sampling rate is too low');
end

newsignal = signal';
t = (0:length(newsignal)-1).*(1/fs);
subplot(2,1,1)
%plot(newsignal);
plot(t,newsignal);
title('Time Domain');
xlabel('Time (sec)');
ylabel('Amplitude');

%fourier transform, frequency domain
fouriersig = abs(fft(newsignal));
fx = (0:length(fouriersig)-1)*(fs/length(fouriersig)); %puts in Hertz
fxlength = length(fx);

subplot(2,1,2)
plot(fx,fouriersig);
title('Frequency Domain');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

%find the highest signal peak values
[~, I] = maxk(fouriersig(1:((fxlength-1)/2)),5);

%using previous array, identify highest and lowest frequencies
lowfreq = fx(min(I));
highfreq = fx(max(I));

%frequency encoding arrays
lowkey = [697, 770, 852, 941];
highkey = [1209, 1336, 1477];

%create arrays to find the frequencies that matches the low key and high key
%frequencies as closely as possible 
low = zeros(1,4);
for i = 1:4
    low(i) = abs(lowkey(i) - lowfreq);
end

high = zeros(1,3);
for i = 1:3
    high(i) = abs(highkey(i) - highfreq);
end

lofi = find(low == min(low)); %low frequency index
hifi = find(high == min(high)); %high frequency index

keys = ['1', '2', '3';
        '4', '5', '6';
        '7', '8', '9';
        '*', '0', '#'];

key = keys(lofi,hifi);


end

