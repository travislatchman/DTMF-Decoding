function [x,fs] = DTMFencode(key,duration,weight,fs)

narginchk(1, 4);

%Check number of arguments passing through function
if nargin == 1
    duration = 0.2;
    weight = [1 1];
    fs = 8000;
elseif nargin == 2
    weight = [1 1];
    fs = 8000;
elseif nargin == 3
    fs = 8000;
end

%Determine which frequencies to use based on key entered
if key == '1'
    w1 = 697;
    w2 = 1209;
elseif key == '2'
    w1 = 697;
    w2 = 1336;
elseif key == '3'
    w1 = 697;
    w2 = 1477;
elseif key == '4'
    w1 = 770;
    w2 = 1209;
elseif key == '5'
    w1 = 770;
    w2 = 1336;
elseif key == '6'
    w1 = 770;
    w2 = 1477;
elseif key == '7'
    w1 = 852;
    w2 = 1209;
elseif key == '8'
    w1 = 852;
    w2 = 1336;
elseif key == '9'
    w1 = 852;
    w2 = 1477;
elseif key == '*'
    w1 = 941;
    w2 = 1209;
elseif key == '0'
    w1 = 941;
    w2 = 1336;
elseif key == '#'
    w1 = 941;
    w2 = 1477;
else
    error('Invalid Input')
end

%apply frequencies and weights to sine equation
t = 0:(1/fs):duration;
y = weight(1)*sin(2*pi*w1*t) + weight(2)*sin(2*pi*w2*t);

%Plot Time Domain of signal
subplot(2,1,1)
plot(t,y);
title("Time-Domain Signal of Digit " + key);
xlabel("Time (sec)");
ylabel("Amplitude");

%Take fourier transform and plot fourier domain
subplot(2,1,2)
fourier = fft(y);
fx = (0:length(fourier)-1)*(fs/length(fourier));
plot(fx, abs(fourier));
title("Fourier-Domain Signal of Digit " + key);
xlabel("Frequency (Hz)");
ylabel("Amplitude");

%rewrite asterik key so error does not occur when audio file is created
if key == '*'
    key = 'star';
end

%write signal into a .wav file
audiowrite("digit"+key+".wav",y,fs);

end
