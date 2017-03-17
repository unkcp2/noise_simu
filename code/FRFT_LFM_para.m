function [Fafbest,po,sig] = FRFT_LFM_para(x,fs,T)
% '2005-分数阶傅里叶变换数值计算中的量纲归一化-X-X-赵兴浩-140524.pdf'
% 仿真运用FrFT的过程,即先尺度变换,再FrFt,最后尺度反变换
% 通过仿真可以看出,若不经尺度变换,频率轴的结果没有影响(即对初始频率的估计没有影响),
% 但对调频斜率的估计有影响,真实的调频斜率为估计结果乘以 (fs/T)
% by YSW 20140527

dt = 1 / fs;        % 采样周期
% t = -T/2:dt:T/2-dt; % 时间轴
t = 0:dt:T-dt; % 时间轴
N = T*fs;
% SNRdB = 0;          % 信噪比
simType = 2;        % 1-不进行尺度变换的处理;2-经尺度变换的处理

% f = (-N/2:N/2-1)/N*fs;
f = (0:N-1)/N*fs;

% 离散尺度变化
% 参考文献'2005-分数阶傅里叶变换数值计算中的量纲归一化-赵兴浩'
tb = T;
fb = fs;
S = sqrt(tb/fb);
xb = sqrt(tb*fb);

if simType==1
    ft = f;
    tt = t;
else
    tsp = 1/xb;
    tt = -xb/2:tsp:xb/2-tsp;    % 变换后的时间轴
    ft = f * S;                 % 变换后的频率轴
end

% 由粗到精搜索
Nstep = 2;
for kk = 1:Nstep
    if kk==1
        p = 0:10^-(kk+1):2;
    else
        [~,col] = find(abs(Faf)>max(abs(Faf(:)))/2);
        p = p(col(1)):5*10^-(kk+2):p(col(end));
    end
    Np = numel(p);
    Faf = zeros(N,Np);
    for ii = 1:Np
        Faf(:,ii) =  frft(x(1,:),p(ii));
    end
   
end
%     figure()%接收信号的FRFT三维图
%     mesh(p,ft,abs(Faf));
%     title('FRFT of Noisy Signal');
%     x1=xlabel('Order p');
%     x2=ylabel('Domain u');
%     zlabel('Amplitude');
%     set(x1,'Rotation',30);
%     set(x2,'Rotation',-30);
% 搜索峰值
[~,ix] = max(abs(Faf(:)));
[row,col] = ind2sub(size(Faf),ix);
po = p(col);                   % 阶数估计
Fafbest = frft(x,po);

uo = ft(row);                  % u域取值估计
alpha = po*pi/2;
mute = -cot(alpha);            % 调频斜率估计(变换后)
f0te = uo * csc(alpha);       % 中心频率估计(变换后)
% 中心频率估计
if simType==1
    f0e = f0te;
else
    f0e = f0te * sqrt(fs/T);
end
mue = mute * fs/T ;           % 调频斜率估计


% figure()
% plot(ft, Fafbest);
window1=[zeros(1,row-10),ones(1,20),zeros(1,length(ft)-row-10)]';%带限的窗
Faf_cut=window1.*Fafbest;%将分数阶傅里叶域的信号带限分理出LFM信号
sig = Faf_cut;

% disp('[mu,mue]')
% disp([mu,mue])
% disp('[f0,f0e]')
% disp([f0,f0e])
