function public_fun()
global fs Tsyn Tdata T_proctective f_syn_start B_syn f_data_start B_data 
% fs = 4e5;           %采样率400KHz
fs = 100000;           %采样率60KHz
Tsyn = 1;           %同步信号1s
% Tdata = 0.02048;     %数据持续时间
Tdata = 0.05;     %数据持续时间
% T_proctective = 0.02048;      %保护间隔
T_proctective = 0.05;      %保护间隔
f_syn_start = 4e3;  %同步信号扫频起始值
% f_syn_start = 24000;  %同步信号扫频起始值
B_syn = 4e3;    %同步信号带宽

f_data_start = 4e3; %数据段起始频率
% f_data_start =24000; %数据段起始频率
B_data = 4e3;   %数据段信号带宽

end