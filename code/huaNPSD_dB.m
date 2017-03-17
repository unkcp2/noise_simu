function y_p_dB=huaNPSD_dB(x,fs)
% nfft= 2^nextpow2(length(x));%�ҳ�����y�ĸ���������2��ָ��ֵ���Զ��������FFT����nfft��
nfft = 400000;
% x=x-mean(x);%ȥ��ֱ������
y_ft=fft(x,nfft);%��y�źŽ���FFT���õ�Ƶ�ʵķ�ֵ�ֲ�
y_p=y_ft.*conj(y_ft)/nfft; %conj()��������y�����Ĺ������ʵ���Ĺ������������
y_f=fs*(0:nfft/2-1)/nfft;%FFT�任���Ӧ��Ƶ�ʵ�����
y_p_dB = 10*log10(y_p(1:nfft/2));

% y_f2 = 0:1:fs/2-1;
% y_p_dB  = interp1(y_f,y_p_dB,y_f2,'linear');
% y_f = y_f2;
y_p_dB = mapminmax(y_p_dB,-45,-5);%��һ��

plot(y_f,y_p_dB);
ylabel('NPSD(dB)');xlabel('Frequency(Hz)');
grid on;