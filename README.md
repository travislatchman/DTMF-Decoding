# DTMF-Decoding  

‘Dual Tone Multi-Frequency’, or “touch-tone” is a signaling method to indicate a phone number without requiring a telephone operator. We will develop a system that gets an
audio recording of a phone number being dialed and needs to guess what that number is from the sounds
the keypad is producing. The algorithm has to be flexible enough to decode any mobile manufacturer (i.e.
any duration and weighting of DTMF tones), any dialing speed (i.e. a sequence of numbers with unknown
onset times), and any noisy environment 

## Part 1 – Encoding DTMF
In order to encode the keys, we need to ensure that there is at least one argument that passes
through the function. The arguments of the encode function are the key number, the duration of
the key, the weight of each frequency and the sampling rate. The default values for the function
if only the key is inputted are 200 milliseconds for the duration, amplitude of 1 for both weights
([1 1]) of the low and high frequencies, and a sampling rate of 8000 hertz. An if statement is
used to compensate for the amount of arguments the user inputs.  

The next if statement is utilized for each of the twelve possible keys to determine which
frequencies will be used for the signal that is being encoded. For example, if a ‘2’ is entered into
the function statement, then the values of 697 Hz and 1336 Hz will be chosen to be used in the
signal equation (sine functions). The sampling rate is used for the time step (1/fs) to help
determine the time values from zero to the duration given by the user or the default value (0.2
ms).  

The Fourier transform of the equation is taken using the fft function. The domain for the Fourier
signal was determined by multiplying the length of the Fourier signal by the sampling rate
divided by the length of the Fourier signal. The subplot function is used for both the time domain
and fourier transform to plot both together on one graph for comparison. Finally, the original
signal is then converted into a .wav file using the “audiowrite” function. Below are the time
domain and fourier domain plots of each of the 12 keys.  

![image](https://user-images.githubusercontent.com/32372013/213828000-4d226947-8be2-42aa-9432-a07b06de0a09.png)  
![image](https://user-images.githubusercontent.com/32372013/213828045-9fe83dfe-a7a2-49b1-a170-44224addd8a7.png)
![image](https://user-images.githubusercontent.com/32372013/213828068-c77129ac-6bd7-467c-8080-fb7dc046fd4e.png)
![image](https://user-images.githubusercontent.com/32372013/213828095-36a32c0e-8dd6-4e1d-a079-40acc581eb4b.png)
![image](https://user-images.githubusercontent.com/32372013/213828186-d280630c-465b-4466-8b22-c118fa12af41.png)
![image](https://user-images.githubusercontent.com/32372013/213828206-b5988463-cae5-4c0b-9a56-8d62f691188d.png)
![image](https://user-images.githubusercontent.com/32372013/213828217-a5e6ce86-bf18-4de8-945c-0257407834dd.png)
![image](https://user-images.githubusercontent.com/32372013/213828252-c8bbea90-c618-4dd2-94e2-fa118bbde8bc.png)
![image](https://user-images.githubusercontent.com/32372013/213828286-5d74ca5e-5177-4ab9-a727-e6d4bcecefab.png)
![image](https://user-images.githubusercontent.com/32372013/213828324-4c95094f-c499-436b-a676-136ad33afe60.png)
![image](https://user-images.githubusercontent.com/32372013/213828341-a54e1f09-68ee-471a-8b52-b464d8fe3e18.png)

## Part 2 – Decoding DTMF keys
In order to decode the key properly, we need to read in the audio file and separate it into the
signal and sampling rate. The best way to decode this signal is by analyzing the Fourier
transform of the signal.  

The Fourier domain of the signal is much easier to look at because of how simplified it is
compared to the original signal in the time domain and because it shows the frequencies. The
code starts off with an if statement to make sure that the file passed in is above 3000 Hz.  

Using the “fft” function, we do the fourier transform of the signal and store the x-axis values into
another variable to represent the values in Hertz. We then store the peak values of the fourier
signal into a matrix ([~,I]) using the maxk function on the first half of the signal. We store the
two frequency values of the x-axis where the minimum and maximum peak values occur to help
us find the frequencies that would fit the keys. This was done by using the min and max
functions on the fx variable in conjunction with the stored “I” values.  

Using the two frequency values we have stored, we subtract them from the arrays we created for
the encoded frequencies for low (697, 770, 852, 941) and high (1209, 1336, 1477) and take the
absolute value of them. The low frequency array are our rows and the high frequency array are
our columns for the frequency key matrix. By doing this, we can use the “find” function in along
with the “min” function to find the lowest difference values. We create a matrix for the keys and
use the lowest difference values as our indices to decipher which key the audio signal
corresponds with. Below is a graph showing the decode function used on the “9” digit key with a
duration of 200 milliseconds.  

![image](https://user-images.githubusercontent.com/32372013/213828976-39643b0b-aeaa-4237-a269-de06ea7e058d.png)

## Part 3 – Decoding DTMF sequences  
In order to decode the DTMF sequences the first thing to do is to read in the audio file similar to
part 2. The signal is separated into the signal and sampling rate. Below is the example of the
signal for “dtmf20.wav” before the noise is removed.  

![image](https://user-images.githubusercontent.com/32372013/213829039-fe991398-5f15-4384-8ad5-5cfe201f98bd.png)

To help remove the noise on the signal, a bandpass filter is applied to filter frequencies lower
than the minimum frequency (697 Hz) and higher than the maximum frequency (1477 Hz).  

After using the bandpass filter, the noise is cleaned up further using an OR statement to remove
any frequencies that do not match the key tones provided. The wav files for “dtmf18”, “dtmf19”,
and “dmtf20” caused the most issues with decoding the sequences, so the “noiseremoved”
statement used in my code was specifically written to accommodate for these discrepancies. This
same “noiseremoved” statement works for the other seventeen dtmf files. Below shows after the
noise is removed.  

![image](https://user-images.githubusercontent.com/32372013/213829152-76b5baa1-3605-48f4-a5d8-9183bfbb3d66.png)  
Next, we create an array that identifies sudden jumps in the in the amplitude of the signal and
stores the corresponding x-axis values where the jumps occur. We do this by using the “find”
function on our signal with the noise removed. A for-loop with an if-statement inside is used to
iterate through the length of the signal to see if the difference between each index in the
sequence is greater than 100. If it is greater than 100, we store the value of the sequence into our
“keypress” array.  

The rest of the code decodes each of the jumps using the same method for part 2 when decoding
individual keys. A for-loop is used to iterate through each of the indices in the array to identify
each key in the sequence. At the start of the for-loop, we find if the difference between the key
presses is greater than 500, and if it is we then go through the process of our decode for part 2
and store the key presses into a new array which lists out the sequence in a string. The final
sequence for the “dtmf20.wav” file is ‘1965’.

