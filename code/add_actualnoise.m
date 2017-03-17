function [Y,NOISE_simu,ks,kv]=add_actualnoise(X,SNR,fs)

global f_data_start B_data Tdata

public_fun();
fc = 20000;
f_data_start = f_data_start + fc;
t = 0:1/fs:Tdata - 1/fs;

load noiseactual.mat
fb =400000;
if fs~=fb
%     X= resample(X,fs,fb);
    noise = resample(noise,fs,fb);
end
nx=length(X(:));

NOISE_simu=noise(1:nx);

% figure
% plot(t,NOISE);
% figure
% hua_fft(NOISE_simu,fs,1);

NOISE_simu=NOISE_simu-mean(NOISE_simu);

fp1 = f_data_start ;
fp2 = f_data_start + B_data;

NOISE_simu = bandp(NOISE_simu,fp1,fp2,fs); %通过滤波器滤除带外噪声，留下信号带内噪声

% figure
% hua_fft(NOISE_simu,fs,1);

signal_power = sum(abs(X(:)).^2)/nx;
noise_variance = signal_power / ( 10^(SNR/10) );
% NOISE_simu=sqrt(noise_variance)/std(NOISE_simu)*NOISE_simu;
NOISE_simu=sqrt(noise_variance/2)/std(NOISE_simu)*NOISE_simu + i*sqrt(noise_variance/2)/std(NOISE_simu)*NOISE_simu;
% figure
% plot(t,NOISE_simu);
% title('Noise Simulation in Time Domain');
% xlabel('Time(s)');
% ylabel('Amplitude');
% figure
% hua_fft(NOISE_simu,fs,1);
% title('Noise Simulation in Frequency Domain');
% xlabel('Frequency(Hz)');
% ylabel('Amplitude');
ks = mean(abs(X).^4)/(mean(abs(X).^2))^2;
kv = mean(abs(NOISE_simu).^4)/(mean(abs(NOISE_simu).^2))^2; 
Y=X+NOISE_simu;

