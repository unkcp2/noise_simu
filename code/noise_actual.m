clear all;
clc;
close all;

global fs Tdata
public_fun();
%Ƶ�ʳ��������FIR�˲��� 
fs = 400000;
N = fs;
L = 0:N-1;
t = 0:1/fs:Tdata - 1/fs;
%������λ����
alpha = (N-1)/2;
k1 = 0:N/2-1;
k2 = N/2+1:N-1;
theta = [-alpha*(2*pi)/N*k1,0,alpha*(2*pi)/N*(N-k2)];
% figure
% plot(L,theta);
% title('Phase Response');
% grid on;

%������������
FileID=fopen('NOISE.bin','rb');
% noise = fread(FileID,'double'); % ��NI�ɼ����ɼ�ʱ
noise = fread(FileID,'float')';  % ��MCC�ɼ�ʱ
fclose(FileID);
% figure
% plot(noise);%�����źŵ�ʱ��ͼ
% figure
% hua_fft(noise,fs,1);%�����źŵ�Ƶ��-��ֵͼ

%��ʵ��15s6000000��������Ϊ300�Σ�ÿ��20000��
noise_len = length(noise);
for(i=1:30)
    noise_s(i,:) = noise(noise_len/30*(i-1)+1:noise_len/30*i);
    knoise_s(i) = mean(abs(noise_s(i,:)).^4)/(mean(abs(noise_s(i,:)).^2))^2; 
end

mknoise = mean(knoise_s);%����300�ε�ƽ����̬ϵ��

%ѡȡ��ӽ���ֵ����������Ϊ�˲����ķ�����Ӧ��С
for(i=1:30)
    dknoise(i) = abs(knoise_s(i) - mknoise);
    k = find(dknoise == min(dknoise));
end

noise = noise_s(k,:);
knoise = knoise_s(k);
figure
plot(noise);%������ʱ��ͼ
title('Actual Noise in Time Domain');
xlabel('Time(s)');
ylabel('Amplitude');
figure
hua_fft(noise,fs,1);%������Ƶ��-��ֵͼ
title('Actual Noise in Frequency Domain');
xlabel('Frequency(Hz)');
ylabel('Amplitude');

nmin=min(noise);
nmax=max(noise);
ampl=linspace(nmin,nmax,100); %�������С����ֳ�n���ȷֵ�
plob=hist(noise,ampl); %�����������ĸ���
plob=plob/length(noise); %�����������ĸ���

figure
bar(ampl,plob); %���������ܶȷֲ�ͼ
ylabel('Plobability');xlabel('Amplitude');title('Probability Density');
hold on;
plot(ampl,plob,'k');
ylabel('Plobability');xlabel('Amplitude');title('Probability Density');

figure
NL = huaNPSD_dB(noise,fs);
title('Power Spectrum of Actual Noise');

%��չ��2*pi
B = fliplr(NL);
NL(N/2+1:N) = B;
Hg = NL;
Hg_li = 10.^(Hg/10);    %dB��λ����Ϊ����
% figure
% plot(L,Hg);
% grid on;
% title('Amplitude Responses');
% xlim([0,N/2]);

% impulse response
H = Hg_li.*exp(1j*theta); 
hn = real(ifft(H));

figure
plot(hn);
xlim([196000,204000]);
grid on;
title('Unit Impulse Response');
figure
freqz(hn,1);
hn = hn(199000:201000);%��ȡƵ����Ӧ

%��Ŀ��kurtosisϵ������n
beta_y = knoise;%����ָ����Ŀ��kurtosisϵ��
sum1 = (sum(hn.^2))^2;
sum2 = sum(hn.^4);
beta_x = (beta_y-3)*(sum1/sum2)+3
syms n
F = gamma(4*n)/(gamma(2*n))^2-(2/3)*beta_x;
n = double(solve(F));
out = 1.5*gamma(4*n)/(gamma(2*n))^2  %��֤�ⷽ�̽��
% solve('gamma(4*n)/(gamma(2*n))^2 = (2/3)*beta_x','n');

%��������������ɰ�����
T_noise = 0.05;
t = 0:1/fs:T_noise - 1/fs;
N_noise = fs*T_noise;
tt = rand(1,10*N_noise);
for m = 1:5*N_noise;
    x(m) =(log(1./tt(2*m-1)).^n).*sin(2*pi.*tt(2*m));
end
x = x(1:N_noise );
figure
plot(t,x);
title('The White Noise');
xlabel('Time(s)');
ylabel('Amplitude');

figure
hua_fft(x,fs,1);
title('The White Noise in Frequency Domin');
xlabel('Frequency(Hz)');
ylabel('Amplitude');

kx = mean(abs(x).^4)/(mean(abs(x).^2))^2;

%ͨ���˲����õ�ɫ����

noise = conv(x,hn);
len = length(noise);
noise = noise((len-N_noise)/2+1:end-(len-N_noise)/2);
ky = mean(abs(noise).^4)/(mean(abs(noise).^2))^2;
figure
plot(t,noise);
title('The Colored Noise');
xlabel('Time(s)');
ylabel('Amplitude');

figure
hua_fft(noise,fs,1);
title('The Colored Noise in Frequency Domin');
xlabel('Frequency(Hz)');
ylabel('Amplitude');

figure()
[y_p_dB]=huaNPSD_dB(noise,fs);
title('Power Spectrum of Simulation Noise');

save noiseactual noise


% figure()
% hua_fft(noise_actual,fs,2);