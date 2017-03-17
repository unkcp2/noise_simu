function y=bandp(x,fp1,fp2,Fs)
%��ͨ�˲�
%ʹ��ע�����ͨ��������Ľ�ֹƵ��������ʵ�ѡȡ��Χ�ǲ��ܳ��������ʵ�һ��
%����f1,f3,fs1,fsh,��ֵС�� Fs/2
%x:��Ҫ��ͨ�˲�������
% f 1��ͨ����߽�
% f 3��ͨ���ұ߽�
% fs1��˥����ֹ��߽�
% fsh��˥���ֹ�ұ߽�
%rp���ߴ���˥��DB������
%rs����ֹ��˥��DB������
%FS������x�Ĳ���Ƶ��
% f1=300;f3=500;%ͨ����ֹƵ��������
% fsl=200;fsh=600;%�����ֹƵ��������
% rp=0.1;rs=30;%ͨ����˥��DBֵ�������˥��DBֵ
% Fs=2000;%������
%
% wp1=2*pi*f1/Fs;
% wp3=2*pi*f3/Fs;
% wsl=2*pi*fsl/Fs;
% wsh=2*pi*fsh/Fs;
% wp=[wp1/pi,wp3/pi];
% ws=[wsl/pi,wsh/pi];
%
% ����б�ѩ���˲�����
% [n,wn]=cheb1ord(wp,ws,rp,rs);
% [b,a]=cheby1(n,rp,wn);
% y=filter(b,a,x);
% [h,w]=freqz(b,a,512,Fs);
% % �鿴����˲���������
% h=20*log10(abs(h));
% figure;plot(w,h);title('������˲�����ͨ������');grid on;

%�����ʸ���Լ5000Hz,ֻ�ܲ�����������˲�����������ͳ�˲���������
d=fdesign.bandpass('N,F3dB1,F3dB2',6,fp1,fp2,Fs);
hd = design(d,'butter');
y = filter(hd,x);
% fvtool(hd);

end