function SNR_out = huaresult(a,b)

global f_data_start B_data Tdata fs

public_fun();
fc = 20000;
f_data_start = f_data_start + fc;
t = 0:1/fs:Tdata - 1/fs;
N = fs*Tdata;
f = (0:N-1)/N*fs;

load ReciveData.mat
% rec = resample(rec,1,4);%将采样率降为原来的1/4
% fs = fs/4;
% t = -Tdata/2:1/fs:Tdata/2 - 1/fs;
% N = fs*Tdata;
% f = (-N/2:N/2-1)/N*fs;

h      = 1;
%计算最优a，b条件下的输出信噪比
y     = sr(a,b,h,rec);

SNR_out = SNR_M2M4(ks,kv,y);


figure ()
subplot 311
plot(t,y);
title('SR Signal in Time Domain');
xlabel('Time');
xlim([0.01,t(end)]);
ylabel('Amplitude');
subplot 312
fb =  f_data_start - B_data;
fe = f_data_start + 2*B_data;
hua_fft(y,fs,1);
xlim([fb,fe]);
title('SR Signal in Frequency Domain');
xlabel('Frequency');
ylabel('Amplitude');

[~,p_y,~] = FRFT_LFM_para(y,fs,Tdata);
frft_y = abs(frft(y,p_y));
subplot 313
plot(f,frft_y);
title('SR Signal in FRFT Domain');
xlabel('u');
ylabel('Amplitude');
