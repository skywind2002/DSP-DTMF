%  根据输入的按键生成DTMF信号并画图的程序
%  每个按键对应两个频率,生成的信号就包括这两个频率
%  至于三角函数信号的产生,采取《数字信号分析与处理》书中5.10.1节中的递推算法

%  首先构建按键到两个频率的映射
keys = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#', 'A', 'B', 'C', 'D'};
freqs = {[697, 1209], [697, 1336], [697, 1477], [770, 1209], [770, 1336], [697, 1477], [852, 1209], [852, 1336], [852, 1477], [941, 1209], [941, 1336], [941, 1477], [697, 1633], [770, 1633], [852, 1633], [941, 1633]};
KeyMap = containers.Map(keys, freqs);

InputKey = input("请输入按键:",'s');
Freqs = KeyMap(InputKey);
f1 = Freqs(1); f2 = Freqs(2); %从MAP映射中读出两个叠加的频率

%  接下来利用正弦振荡器的条件生成三角函数的信号
%  采样率为8kHz,我们生成1s长的信号需要得到8000个采样点
%  生成的信号频率如f1和f2所示
fs = 8000;
T = 1;
%  生成f1的频率信号
w1 = 2 * pi * f1 / fs;
CosSeq1 = zeros(1, fs + 1); SinSeq1 = zeros(1, fs + 1); %给-1点留个位置
CosSeq1(1)=cos(w1); SinSeq1(1)=-sin(w1);
for i=2:8001
  CosSeq1(i)=cos(w1)*CosSeq1(i-1)-sin(w1)*SinSeq1(i-1);
  SinSeq1(i)=sin(w1)*CosSeq1(i-1)+cos(w1)*SinSeq1(i-1);
end

%  再生成f2的频率信号
w2 = 2 * pi * f2 / fs;
CosSeq2 = zeros(1, fs + 1); SinSeq2 = zeros(1, fs + 1); %给-1点留个位置
CosSeq2(1)=cos(w2); SinSeq2(1)=-sin(w2);
for i=2:8001
  CosSeq2(i)=cos(w2)*CosSeq2(i-1)-sin(w2)*SinSeq2(i-1);
  SinSeq2(i)=sin(w2)*CosSeq2(i-1)+cos(w2)*SinSeq2(i-1);
end

%  最后综合产生DTMF信号,设置每个信号的幅度都为1
%  我们这里采用sin信号的相加

OutputSeq=SinSeq1(2:end)+SinSeq2(2:end);  %去掉初始化的第一个单元
t=0:1/fs:1-1/fs;

stem((abs(fft(OutputSeq,200))));  %画FFT看到确实是两个频率峰,验证了我们程序的正确