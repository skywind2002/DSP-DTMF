clear all;
clc;

%  利用Goertzel算法来进行特定频点的频谱分析的程序
%  同样的,我们仍然采取2000点的DFT,这样DFT结果的index和本身的频率就有着相对简单的对应关系

%一样的准备步骤
FilenameList = ["./附件1/data1081.wav", "./附件1/data1107.wav", "./附件1/data1140.wav", "./附件1/data1219.wav", "./附件1/data1234.wav", "./附件1/data1489.wav", "./附件1/data1507.wav", "./附件1/data1611.wav", "./附件1/data1942.wav", "./附件1/data1944.wav"];
len = length(FilenameList); %文件个数
N = 2000; %选择FFT变换点数为2000(因为可以直接用MATLAB现成的FFT变换,所以点数可以随便选)
fs = 8000;
freq = [697, 770, 852, 941, 1209, 1336, 1477, 1633]; %可能出现8个频率
index = floor(freq * N / fs); % 8个频率对应在FFT中的序号
KeyMap = ['1', '2', '3', 'A'; '4', '5', '6', 'B'; '7', '8', '9', 'C'; '*', '0', '#', 'D']; %键盘
X = zeros(1, length(index));

% Goertzel算法的准备步骤
i = 1:8;
Coswk = cos(2 * pi * index(i) / N);
v = zeros(1, N + 1);
output = [];

for i = 1:len
    [x, Fs] = audioread(FilenameList(i));
    x = [x; zeros(N - length(x), 1)];
    % 接下来利用Goertzel算法计算特定频点上的FFT系数(对每个频率都计算一次)
    for k = 1:8
        v(1) = x(1); %初始状态v[1]=x[1]
        v(2) = 2 * Coswk(k) * v(1) + x(2); %初始状态v[2]

        for n = 3:N
            v(n) = 2 * Coswk(k) * v(n - 1) - v(n - 2) + x(n);
        end

        X(k) = abs(v(N) - exp(-1j * 2 * pi * k / N) * v(N - 1));
    end

    %  计算出了特定频率的值以后就可以进行判定
    [rowmax, row] = max(X(1:4));
    [colmax, col] = max(X(5:8));
    output = [output, KeyMap(row, col)];
end

disp(output);
