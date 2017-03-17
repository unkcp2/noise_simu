%---------------------------------����snr����-------------------------------------

clc;
%fm�ź�
%--------------------------------------------
fc = 25000;                       %�ز�Ƶ��
fs = 200000;                       %����Ƶ��
%t = (0 :0.00005:0.15);               %ʱ������
%x = sin(2*pi*30*t);               %�����ź�
[x0,Fs,bits] = wavread('yuyin.wav',[800 3800]);
sigLength=length(x0);
t=(0:sigLength-1)/Fs;
x = x0(:,1);
fmsig = modulate(x,fc,fs,'FM');       %�����ź�

%%%%%%%%%%%%%%�弤��Ӧ%%%%%%%%%%%%%%%%%%%
ARRFIL='E:\���棨bellhop��\Bounce+Bellhop\Test2012_00100.arr';
 [amp,delay,SrcAngle,RcvrAngle,NumTopBnc,NumBotBnc,narrmat,Pos]=read_arrivals_asc(ARRFIL);
Row=size(amp,1);%����amp��1ά�Ĵ�С��������
Column=size(amp,2);%����amp��2ά�Ĵ�С��������
amp_1=reshape(amp',1,Row*Column);
delay_1=reshape(delay',1,Row*Column);
figure
stem(delay_1,amp_1,'fill','o-k');
xlabel('Time(s)','FontSize',12);
ylabel('Amplitude','FontSize',12);
grid on;
%hold on;
%%%%%%%%%%%%�����ź�(filter)%%%%%%%%%%%%%%%
rx=real(filter(amp_1,0.001,fmsig));
%figure
%plot(t,rx);
%xlabel('Time(s)','FontSize',12);
%ylabel('Amplitude','FontSize',12);
%grid on;
nx=rx-fmsig;
        
%snr����
%--------------------------------------------
snr_theory = 5:2:35;  %SNR����ֵ
for m = 1:length(snr_theory)

        [rxsig,noise] = bell(fmsig,nx,snr_theory(m));
       
        % ���ú���envelope
        %--------------------------------------------
        [up,down] = envelope(t,rxsig,'linear');
        
        % ��ʾ�źŰ���
        %--------------------------------------------
        %figure
        %plot(t,y,'g-');
        %hold on;
        %plot(t,up,'r-.');
        %title('�źŰ���');
        %hold off;

        % ���ð������snr
        %--------------------------------------------
        uu=abs(up); %����ֵ
        j=find(uu>0);
        u=uu(j);
        M2 = mean(u); %2�׾� 
        M4 = mean(u.^2); %4�׾�       
        z=(M4-M2^2)/M2^2;
        z2= sqrt(abs(1/(1-z)))-1;       
        snr(m) = 10*log10(abs(1/z2));
        
        if snr_theory(m)==5
            figure
            subplot(211)
            plot(t,fmsig,'k');
            xlabel('t(s) ');
            ylabel('Amplitude');
            %legend('The Fm signal',4); 
            title('The Fm signal Curve');
            subplot(212)
            plot(t,rxsig)
            xlabel('t(s)');
            ylabel('Amplitude');
            %legend('The Fm signal with Bellhop noise',1); 
            title('The Fm signal Curve with Bellhop noise when snr=5');
            
            fm=abs(fft(fmsig,3000));
            rx=abs(fft(rxsig,3000));
            f=(0:length(fm)-1)'*fs/length(fm);
            figure
            subplot(211)
            plot(f,fm,'k');
            xlabel('frequency(Hz) ');
            ylabel('Amplitude');
            %legend('The Fm signal',4); 
            title('The Fm signal Spectrum Curve');
            subplot(212)
            plot(f,rx)
            xlabel('frequency(Hz)');
            ylabel('Amplitude');
            %legend('The Fm signal with Bellhop noise',1); 
            title('The Fm signal Spectrum Curve with Bellhop noise when snr=5');
        end 
end

%snrr = snr;
%snrrr = sort(snrr);
%Spea = pearson(snr_theory,snrrr)
ww1=snr_theory;
ww2=snr;
[h1,h2] = sort(ww1);
[hh1,hh2] = sort(ww2);
Spearman = pearson(h2,hh2)   %Spearman�����ϵ��    
Pearson = pearson(snr_theory,snr)   %Pearson���ϵ��
NMSE = ((snr_theory-snr)./snr_theory).^2;  %��һ���������
MNMSE = mean(NMSE)  %��һ����������ֵ  
figure
subplot(211)
plot(snr_theory,snr_theory,'r');
hold on
plot(snr_theory,snr,'-o');
hold off
xlabel('snr-theory(dB) ');
ylabel('snr-estimate(dB)');
legend('Theory snr Curve','Estimate snr Curve',4); 
title('Theory and Estimate snr Curves');
grid on
subplot(212)
semilogy(snr_theory,NMSE,'-*')
xlabel('snr(dB)');
ylabel('Normalized Mean Squared Error');
legend('Normalized Mean Squared Error Curve',1); 
title('Normalized Mean Squared Error Curve');
grid on
