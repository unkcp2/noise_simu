function y=bandp(x,fp1,fp2,Fs)
%带通滤波
%使用注意事项：通带或阻带的截止频率与采样率的选取范围是不能超过采样率的一半
%即，f1,f3,fs1,fsh,的值小于 Fs/2
%x:需要带通滤波的序列
% f 1：通带左边界
% f 3：通带右边界
% fs1：衰减截止左边界
% fsh：衰变截止右边界
%rp：边带区衰减DB数设置
%rs：截止区衰减DB数设置
%FS：序列x的采样频率
% f1=300;f3=500;%通带截止频率上下限
% fsl=200;fsh=600;%阻带截止频率上下限
% rp=0.1;rs=30;%通带边衰减DB值和阻带边衰减DB值
% Fs=2000;%采样率
%
% wp1=2*pi*f1/Fs;
% wp3=2*pi*f3/Fs;
% wsl=2*pi*fsl/Fs;
% wsh=2*pi*fsh/Fs;
% wp=[wp1/pi,wp3/pi];
% ws=[wsl/pi,wsh/pi];
%
% 设计切比雪夫滤波器；
% [n,wn]=cheb1ord(wp,ws,rp,rs);
% [b,a]=cheby1(n,rp,wn);
% y=filter(b,a,x);
% [h,w]=freqz(b,a,512,Fs);
% % 查看设计滤波器的曲线
% h=20*log10(abs(h));
% figure;plot(w,h);title('所设计滤波器的通带曲线');grid on;

%采样率高于约5000Hz,只能采用面向对象滤波器，上述传统滤波器不适用
d=fdesign.bandpass('N,F3dB1,F3dB2',6,fp1,fp2,Fs);
hd = design(d,'butter');
y = filter(hd,x);
% fvtool(hd);

end