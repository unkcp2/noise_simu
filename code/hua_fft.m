function hua_fft(y,fs,style,varargin)
%��style=1,����ֵ�ף���style=2,��������;��style=�����ģ���ֵ�׺͹�����
%��style=1ʱ�������Զ�����2����ѡ��������ѡ�������������������Ҫ�鿴��Ƶ�ʶε�
%��һ������Ҫ�鿴��Ƶ�ʶ����
%�ڶ�������Ҫ�鿴��Ƶ�ʶε��յ�
%����style���߱���ѡ���������������뷢��λ�ô���
nfft= 2^nextpow2(length(y));%�ҳ�����y�ĸ���������2��ָ��ֵ���Զ��������FFT����nfft��
% nfft=1024;%��Ϊ����FFT�Ĳ���nfft
y=y-mean(y);%ȥ��ֱ������
y_ft=fft(y,nfft);%��y�źŽ���FFT���õ�Ƶ�ʵķ�ֵ�ֲ�
y_p=y_ft.*conj(y_ft)/nfft;%conj()��������y�����Ĺ������ʵ���Ĺ������������
y_f=fs*(0:nfft/2-1)/nfft;%FFT�任���Ӧ��Ƶ�ʵ�����
if style==1
    if nargin==3
        plot(y_f,2*abs(y_ft(1:nfft/2))/length(y));%matlab�İ����ﻭFFT�ķ���
        ylabel('Amplitude');xlabel('Frequency(Hz)');title('Amplitude Spectrum');
        %plot(y_f,abs(y_ft(1:nfft/2)));%��̳�ϻ�FFT�ķ���
    else
        f1=varargin{1};
        fn=varargin{2};
        ni=round(f1 * nfft/fs+1);
        na=round(fn * nfft/fs+1);
        plot(y_f(ni:na),abs(y_ft(ni:na)*2/nfft));
        ylabel('Amplitude');xlabel('Frequency');title('Amplitude Spectrum');
    end
elseif style==2
    plot(y_f,y_p(1:nfft/2));
    ylabel('PSD');xlabel('Frequency');title('Power Spectrum');
else
    subplot(211);plot(y_f,2*abs(y_ft(1:nfft/2))/length(y));
    ylabel('Amplitude');xlabel('Frequency');title('Amplitude Spectrum');
    subplot(212);plot(y_f,y_p(1:nfft/2));
    ylabel('PSD');xlabel('Frequency');title('Power Spectrum');
end
end