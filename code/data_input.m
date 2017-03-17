close all %关闭所有figure
clear all %清除所有内存 
clc       %清除Command Window内容
global fs Tsyn  T_proctective f_syn_start B_syn Tdata f_data_start B_data

public_fun();
fc = 20000;
f_data_start = f_data_start + fc;
t = 0:1/fs:Tdata - 1/fs;
N = fs*Tdata;
f = (0:N-1)/N*fs;
data1 = lwb_chirp(f_data_start,B_data,Tdata,fs);  %数据段
data1 = data1/max(abs(data1))./32; % 水池限制幅度
p = 2*acot(fs/B_data)/pi+1;
Faf1 = abs(frft(data1,p));

%画发送信号时域、频域、FRFT分布图
figure
subplot 311
plot(t,data1);%发送信号的时域图
title('Sended Signal in Time Domain');
xlabel('Time(s)');
ylabel('Amplitude');
subplot 312
fb = f_data_start - B_data;%要求显示频率段截止频率，用于直观看频率-幅值图
fe = f_data_start + 2*B_data;%要求显示频率段截止频率，用于直观看频率-幅值图
hua_fft(data1,fs,1);%发送信号的频率-幅值图
xlim([fb,fe]);
title('Sended Signal in Frequency Domain');
xlabel('Frequency(Hz)');
ylabel('Amplitude');
subplot 313
plot(f,Faf1);%发送信号的FRFT域图
title('Sended Signal in FRFT Domain');
xlabel('u');
ylabel('Amplitude');

% %与频率为fc的本地信号混频搬移频谱至较高频率
% fc = 20000;
% local = cos(2*pi*fc*t);
% data2 = data1.*local;
% figure;
% hua_fft(data2,fs,1,fc,fd+fc);%发送信号的频率-幅值图
% figure
% subplot 311;
% plot(t,real(data2));
% 
%  %经过带通滤波器滤除
% f1 = f_data_start + fc -1000;
% f3 = f_data_start + B_data + fc + 1000;
% fsl = f_data_start + fc -1500;
% fsh = f_data_start + B_data + fc + 1500;
% rp = 0.1;
% rs = 30;
% data2 = highp(data2,f1,fsl,rp,rs,fs);
%  % ks2 = kurtosis(data2)
% subplot 312;
% hua_fft(data2,fs,1,fc,fc+fd);
% subplot 313;
% Faf2 = abs(frft(data2,p));
% plot(f,Faf2);%发送信号的FRFT域图

% %画接收信号时域、频域、FRFT分布图
% [reciv,noise] = gauss_noise(data1,-7,Tdata);%加高斯噪声
% [reciv,noise] = pink_noise(data1,'pink.wav',-5,fs);%加粉红噪声
% [reciv,noise] = outfield_noise(data1,-10,fs);%加五缘湾实际噪声

[rec,noise,ks,kv] = add_actualnoise(data1,-5,fs);%加仿真噪声
SNR1 = SNR_M2M4(ks,kv,rec)
SNR2 = SNR_FRFT(rec,fs,Tdata)
save ReciveData rec kv ks
[Faf_rec,p_rec,Faf_recsig] = FRFT_LFM_para(rec,fs,Tdata);
frft_rec = abs(frft(rec,p_rec));

figure
subplot 311
plot(t,rec);
title('Recived Signal in Time Domain');
xlabel('Time');
ylabel('Amplitude');
subplot 312
hua_fft(rec,fs,1);
xlim([fb,fe]);
title('Recived Signal in Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');
subplot 313
plot(f,frft_rec);
% xlim([fb,fe]);
title('Recived Signal in FRFT Domain');
xlabel('u');
ylabel('Amplitude');