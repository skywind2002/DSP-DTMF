function [head, tail] = AudioSeperate(input)
    %  音频分割函数,能将input中固定时间内功率超过阈值的区间截取出来

    WindowLen = 10; %窗长为10
    DataLen = length(input); %数据长度
    head = []; tail = []; %初始化

    threshold = 0.1; %经过尝试得到的阈值
    isKey = 0; %是否是按键指示变量

    for i = 1:DataLen - WindowLen + 1 %遍历所有长度为WindowLen的区间
        power = sum(input(i:i + WindowLen - 1).^2); %计算功率

        if (power > threshold && isKey == 0) %超过阈值且没检测到为key
            head = [head, i]; %更新起始点
            isKey = 1;
        end

        if (power <= threshold && isKey == 1) %没超过阈值且正在Key中
            tail = [tail, i];
            isKey = 0; %更新结束点
        end

    end

end
