function [Y,NOISE] = gauss_noise(x,SNR,T)

% D    = 0.5; 
% NOISE = sqrt(2*D)*randn(size(x));
% Y    = x+NOISE;
% Y    = Y-mean(Y);
% Y    = Y/max(abs(Y));

% noisegen add white Gaussian noise to a signal.
% [Y, NOISE] = gauss_noise(x,SNR) adds white Gaussian NOISE to x,The SNR is in dB.
NOISE=randn(size(x));
NOISE=NOISE-mean(NOISE);

signal_power = sum(abs(x(:)).^2)/length(x(:));

% a=max(x);
% signal_power = a^2*T^2/2 %LFM信号的能量 (A^2*T^2)/2
% signal_power = var(x);
noise_variance = signal_power / ( 10^(SNR/10) );
% NOISE=sqrt(noise_variance)*NOISE;
% NOISE = sqrt(noise_variance)/std(NOISE)*NOISE;
NOISE = sqrt(noise_variance/2)/std(NOISE)*NOISE + i*sqrt(noise_variance/2)/std(NOISE)*NOISE;
Y=x+NOISE;
