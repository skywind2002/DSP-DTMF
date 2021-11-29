clear all;
clc;

% 基于FFT的担负好DTMF信号识别

FilenameList = ["./附件1/data1081.wav", "./附件1/data1107.wav", "./附件1/data1140.wav", "./附件1/data1219.wav", "./附件1/data1234.wav", "./附件1/data1489.wav", "./附件1/data1507.wav", "./附件1/data1611.wav", "./附件1/data1942.wav", "./附件1/data1944.wav"];
len = length(FilenameList); %文件个数
N = 2000; %选择FFT变换点数为2000(因为可以直接用MATLAB现成的FFT变换,所以点数可以随便选)
fs = 8000;
freq = [697, 770, 852, 941, 1209, 1336, 1477, 1633]; %可能出现8个频率
index = floor(freq * N / fs); % 8个频率对应在FFT中的序号
KeyMap = ['1', '2', '3', 'A'; '4', '5', '6', 'B'; '7', '8', '9', 'C'; '*', '0', '#', 'D']; %键盘
ans = zeros(1, len);

for i = 1:len
    [y, Fs] = audioread(FilenameList(i));
    %  通过打印length(y)我们可以发现,10个文件中的音频信号数组长度都在2000以内
    %  且音频信号都是-1~1之间的整数
    %  我们利用FFT的方法进行频谱分析
    yFFT = abs(fft(y, N)); %得到2000点FFT数据,其中第i个点代表f=4*i的频率分量
    stem(yFFT);
    SampleAmp = (yFFT(index) + yFFT(index - 1) + yFFT(index) + 1) / 3; %做个滑动平均防止有点偏差
    [rowmax, row] = max(SampleAmp(1:4)); %前四个判断行号
    [colmax, col] = max(SampleAmp(5:8)); %后四个判断列号
    output(i) = (KeyMap(row, col));
end
