function [x,fs] = DTMFencode2(key,duration,weight,fs)

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
if key == '1' | key == "11"
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
elseif key == '*' | key == '10'
    w1 = 941;
    w2 = 1209;
    key = '*';
elseif key == '0'
    w1 = 941;
    w2 = 1336;
    key = '0';
elseif key == '#' | key == "12"
    w1 = 941;
    w2 = 1477;
    key = '#';
else
    error('Invalid Input')
end

%apply frequencies and weights to sine equation
t = 0:(1/fs):duration;
x = weight(1)*sin(2*pi*w1*t) + weight(2)*sin(2*pi*w2*t);

%rewrite asterik key so error does not occur when audio file is created


end