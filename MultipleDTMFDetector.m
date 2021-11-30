[data, fs] = audioread('./附件2/data.wav');
plot(data); %y的图像表明这个音频信号一共有15段
hold on;
data_head=zeros(1,length(data));
data_tail=zeros(1,length(tail));
[head, tail] = AudioSeperate(data); %进行数据分割
data_head(head)=2;
data_tail(tail)=2;
plot(data_head,'r');
plot(data_tail,'g');
num = length(head); %分割段数
N = 2000; %选择FFT变换点数为2000(因为可以直接用MATLAB现成的FFT变换,所以点数可以随便选)
fs = 8000;
freq = [697, 770, 852, 941, 1209, 1336, 1477, 1633]; %可能出现8个频率
index = floor(freq * N / fs); % 8个频率对应在FFT中的序号
KeyMap = ['1', '2', '3', 'A'; '4', '5', '6', 'B'; '7', '8', '9', 'C'; '*', '0', '#', 'D']; %键盘
output_FFT = [];

for i = 1:num %对每一段进行单DTMF_FFT解码
    input = data(head(i):tail(i)); %input为进行分析的段数据
    inputFFT = abs(fft(input, N));
    SampleAmp = (inputFFT(index) + inputFFT(index - 1) + inputFFT(index + 1)) / 3; %求平均
    [rowmax, row] = max(SampleAmp(1:4));
    [colmax, col] = max(SampleAmp(5:8));
    output_FFT = [output_FFT, KeyMap(row, col)];
end

disp(output_FFT);

%对每一段进行DTMF_Goertzel解码
i = 1:8;
Coswk = cos(2 * pi * index(i) / N);
v = zeros(1, N + 1);
X = zeros(1, length(index));
output_Goertzel = [];

%这段注释见单独的Goertzel算法
for i = 1:num
    input = data(head(i):tail(i));
    input = [input; zeros(N - length(input), 1)];

    for k = 1:8
        v(1) = input(1);
        v(2) = input(2) + 2 * Coswk(k) * v(1);

        for n = 3:N
            v(n) = 2 * Coswk(k) * v(n - 1) - v(n - 2) + input(n);
        end

        X(k) = abs(v(N) - exp(-1j * 2 * pi * k / N) * v(N - 1));
    end

    [rowmax, row] = max(X(1:4));
    [colmax, col] = max(X(5:8));
    output_Goertzel = [output_Goertzel, KeyMap(row, col)];
end

disp(output_Goertzel);
