close all %�ر�����figure
clear all %��������ڴ� 
clc       %���Command Window����
global fs Tsyn  T_proctective f_syn_start B_syn Tdata f_data_start B_data

public_fun();
fc = 20000;
f_data_start = f_data_start + fc;
t = 0:1/fs:Tdata - 1/fs;
N = fs*Tdata;
f = (-N/2:N/2-1)/N*fs;
data1 = lwb_chirp(f_data_start,B_data,Tdata,fs);  %���ݶ�
data1 = data1/max(abs(data1))./32; % ˮ�����Ʒ���
p = 2*acot(fs/B_data)/pi+1;
Faf1 = abs(frft(data1,p));

% %�������ź�ʱ��Ƶ��FRFT�ֲ�ͼ
% figure
% subplot 311
% plot(t,data1);%�����źŵ�ʱ��ͼ
% title('Sended Signal in Time Domain');
% xlabel('Time');
% ylabel('Amplitude');
% subplot 312
% fd = 2*f_data_start + B_data;%Ҫ����ʾƵ�ʶν�ֹƵ�ʣ�����ֱ�ۿ�Ƶ��-��ֵͼ
% hua_fft(data1,fs,1,0,fd);%�����źŵ�Ƶ��-��ֵͼ
% title('Sende Signal in Frequency Domain');
% xlabel('Frequency');
% % xlim([0,12000])
% ylabel('Amplitude');
% subplot 313
% plot(f,Faf1);%�����źŵ�FRFT��ͼ
% title('Sended Signal in FRFT Domain');
% xlabel('u');
% ylabel('Amplitude');

% %��Ƶ��Ϊfc�ı����źŻ�Ƶ����Ƶ�����ϸ�Ƶ��
% fc = 20000;
% local = cos(2*pi*fc*t);
% data2 = data1*local;
% figure
% plot(data2);
% figure
% subplot 211;
% hua_fft(data2,fs,1,fc,fd+fc);%�����źŵ�Ƶ��-��ֵͼ
% 
% % %������ͨ�˲����˳���Ƶ
% f1 = f_data_start + fc -1000;
% f3 = f_data_start + B_data + fc + 1000;
% fsl = f_data_start + fc -1500;
% fsh = f_data_start + B_data + fc + 1500;
% rp = 0.1;
% rs = 30;
% data2 = bandp(data2,f1,f3,fsl,fsh,rp,rs,fs);
% % % ks2 = kurtosis(data2)
% subplot 212;
% hua_fft(data2,fs,1,fc,fd+fc);

% %�������ź�ʱ��Ƶ��FRFT�ֲ�ͼ
% [reciv,noise] = gauss_noise(data1,-7,Tdata);%�Ӹ�˹����
% [reciv,noise] = pink_noise(data1,'pink.wav',-5,fs);%�ӷۺ�����
% [reciv,noise] = outfield_noise(data1,-10,fs);%����Ե��ʵ������

% [rec,noise,ks,kv] = add_actualnoise(data1,-10,fs);%�ӷ�������
% [Faf_rec,p_rec,Faf_recsig] = FRFT_LFM_para(rec,fs,Tdata);
% frft_rec = abs(frft(rec,p_rec));
% figure
% subplot 311
% plot(t,rec);
% title('Recived Signal in Time Domain');
% xlabel('Time');
% ylabel('Amplitude');
% subplot 312
% hua_fft(rec,fs,1,0,fd);
% title('Recived Signal in Frequency Domain');
% xlabel('Frequency');
% ylabel('Amplitude');
% subplot 313
% plot(f,frft_rec);
% title('Recived Signal in FRFT Domain');
% xlabel('u');
% ylabel('Amplitude');

%���ַ������������
snr_theory = -10:1:10;  %SNR����ֵ
for n = 1:length(snr_theory)
    snr_theory(n)
    [reciv,noise] = gauss_noise(data1,snr_theory(n),Tdata);%�Ӹ�˹����
% %     [reciv,noise] = pink_noise(data1,'pink.wav',snr_theory(n),fs);%�ӷۺ�����
% %     [reciv,noise] = outfield_noise(data1,snr_theory(n),fs);%����Ե��ʵ������
%        [reciv,noise] = add_actualnoise(data1,snr_theory(n),fs);%�ӷ�������
% %     [reciv,noise] = doubmod_noise(data1,snr_theory(n));%��˫ģ����
% 
    %������ؾ�������ֵ�ֽ����SNR
    for L = 1:50    
        yn=real(reciv);
        c=xcorr(yn,'coeff');
        len=length(reciv);
        m=100;
        rk = c(len:len+m-1);
        Rxx = zeros(m,m);
        Rxx(1,:)=rk;
        Rxx(m,:)=fliplr(rk);
        for i=2:m-1
            if i>1
                Rxx(i,:)=[fliplr(rk(2:i)),rk(1:m-i+1)];
            end
        end
        [U,S,V]=svd(Rxx);
        for i=1:m
            s_x(i) = S(i,i);
        end
        s_xd = s_x(2:m)-s_x(1:m-1);
        s_xd (60:80);
        for i =1:m-1
            if abs(s_xd(i))<0.1 &abs(s_xd(i+1))<0.1
                p = i-1;
                break;
            end
        end
        noise_p = 1/(m-p)*sum(s_x(p+1:m));
        snr(L)= 10*log10((sum(s_x(1:p))-p*noise_p)/(m*noise_p));
    end
    SNR_SVD(n) = mean(snr);
%     
%     ��M2M4����SNR
    for L = 1:50
        ks = mean(abs(data1).^4)/(mean(abs(data1).^2))^2;
        kv = mean(abs(noise).^4)/(mean(abs(noise).^2))^2; 
%         kv = 3;%����̬�ֲ��У����ϵ����3

        M2 = mean(reciv.*conj(reciv)); %2�׾�
        M4 = mean((reciv.*conj(reciv)).^2); %4�׾�
        ps1(L) = ((kv-2)*M2-sqrt((4-ks*kv)*(M2^2)+(ks+kv-4)*M4))/(ks+kv-4);
        pv1(L) = M2 - ps1(L);
    end
    ps = mean(ps1);
    pv = mean(pv1);
    SNR_M2M4(n) = 10*log10(abs(ps/pv));
%     
    %��FRFT������SNR
    [Faf2,p,Faf_sig] = FRFT_LFM_para(reciv,fs,Tdata);
    sig = (frft(Faf_sig,-p))';  
    sigpower = sum(abs(sig).^2)/length(sig);
    noise2 = real(reciv - sig);
    noipower = sum(abs(noise2).^2)*2/length(noise2);
    SNR_FRFT(n)=10*log10(sigpower/noipower);

%����ƫ��   
%     piancha_svd(n) = abs(snr_theory(n)-SNR_SVD(n)); 
%     piancha_m2m4(n) = abs(snr_theory(n)-SNR_M2M4(n));
%     piancha_frft(n) = abs(snr_theory(n)-SNR_FRFT(n));
end
% RMSE_m2m4 = sqrt(sum((SNR_M2M4-snr_theory).^2)/length(snr_theory))
% RMSE_frft = sqrt(sum((SNR_FRFT-snr_theory).^2)/length(snr_theory))
% RMSE_svd = sqrt(sum((SNR_SVD-snr_theory).^2)/length(snr_theory))
% 
% %��SNR����Ա�ͼ
figure()
plot(snr_theory,snr_theory,'k--','LineWidth',2);
hold on
plot(snr_theory,SNR_M2M4,'g-*','LineWidth',2);
hold on
plot(snr_theory,SNR_FRFT,'b-+','LineWidth',2);
hold on
plot(snr_theory,SNR_SVD,'r-o','LineWidth',2);
hold on
title('SNR Estimation');
xlabel('SNR-Theory');
ylabel('SNR-Estimate');
legend('SNR-Theory','SNR-M2M4','SNR-FRFT','SNR-SVD');
% %������ƫ��ͼ
% figure()
% plot(snr_theory,piancha_m2m4,'g-*','LineWidth',2);
% hold on
% plot(snr_theory,piancha_frft,'b-+','LineWidth',2);
% hold on
% % plot(snr_theory,piancha_svd,'r-o','LineWidth',2);
% % hold on
% title('SNR Estimation  Bias');
% xlabel('SNR-Theory');
% ylabel('SNR-Bias');
% legend('Bias-M2M4','Bias-FRFT');



