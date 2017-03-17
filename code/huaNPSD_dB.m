function y_p_dB=huaNPSD_dB(x,fs)
% nfft= 2^nextpow2(length(x));%找出大于y的个数的最大的2的指数值（自动进算最佳FFT步长nfft）
nfft = 400000;
% x=x-mean(x);%去除直流分量
y_ft=fft(x,nfft);%对y信号进行FFT，得到频率的幅值分布
y_p=y_ft.*conj(y_ft)/nfft; %conj()函数是求y函数的共轭复数，实数的共轭复数是他本身。
y_f=fs*(0:nfft/2-1)/nfft;%FFT变换后对应的频率的序列
y_p_dB = 10*log10(y_p(1:nfft/2));

% y_f2 = 0:1:fs/2-1;
% y_p_dB  = interp1(y_f,y_p_dB,y_f2,'linear');
% y_f = y_f2;
y_p_dB = mapminmax(y_p_dB,-45,-5);%归一化

plot(y_f,y_p_dB);
ylabel('NPSD(dB)');xlabel('Frequency(Hz)');
grid on;