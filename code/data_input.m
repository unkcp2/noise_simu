close all %�ر�����figure
clear all %��������ڴ� 
clc       %���Command Window����
global fs Tsyn  T_proctective f_syn_start B_syn Tdata f_data_start B_data

public_fun();
fc = 20000;
f_data_start = f_data_start + fc;
t = 0:1/fs:Tdata - 1/fs;
N = fs*Tdata;
f = (0:N-1)/N*fs;
data1 = lwb_chirp(f_data_start,B_data,Tdata,fs);  %���ݶ�
data1 = data1/max(abs(data1))./32; % ˮ�����Ʒ���
p = 2*acot(fs/B_data)/pi+1;
Faf1 = abs(frft(data1,p));

%�������ź�ʱ��Ƶ��FRFT�ֲ�ͼ
figure
subplot 311
plot(t,data1);%�����źŵ�ʱ��ͼ
title('Sended Signal in Time Domain');
xlabel('Time(s)');
ylabel('Amplitude');
subplot 312
fb = f_data_start - B_data;%Ҫ����ʾƵ�ʶν�ֹƵ�ʣ�����ֱ�ۿ�Ƶ��-��ֵͼ
fe = f_data_start + 2*B_data;%Ҫ����ʾƵ�ʶν�ֹƵ�ʣ�����ֱ�ۿ�Ƶ��-��ֵͼ
hua_fft(data1,fs,1);%�����źŵ�Ƶ��-��ֵͼ
xlim([fb,fe]);
title('Sended Signal in Frequency Domain');
xlabel('Frequency(Hz)');
ylabel('Amplitude');
subplot 313
plot(f,Faf1);%�����źŵ�FRFT��ͼ
title('Sended Signal in FRFT Domain');
xlabel('u');
ylabel('Amplitude');

% %��Ƶ��Ϊfc�ı����źŻ�Ƶ����Ƶ�����ϸ�Ƶ��
% fc = 20000;
% local = cos(2*pi*fc*t);
% data2 = data1.*local;
% figure;
% hua_fft(data2,fs,1,fc,fd+fc);%�����źŵ�Ƶ��-��ֵͼ
% figure
% subplot 311;
% plot(t,real(data2));
% 
%  %������ͨ�˲����˳�
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
% plot(f,Faf2);%�����źŵ�FRFT��ͼ

% %�������ź�ʱ��Ƶ��FRFT�ֲ�ͼ
% [reciv,noise] = gauss_noise(data1,-7,Tdata);%�Ӹ�˹����
% [reciv,noise] = pink_noise(data1,'pink.wav',-5,fs);%�ӷۺ�����
% [reciv,noise] = outfield_noise(data1,-10,fs);%����Ե��ʵ������

[rec,noise,ks,kv] = add_actualnoise(data1,-5,fs);%�ӷ�������
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