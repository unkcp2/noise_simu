function [Fafbest,po,sig] = FRFT_LFM_para(x,fs,T)
% '2005-�����׸���Ҷ�任��ֵ�����е����ٹ�һ��-X-X-���˺�-140524.pdf'
% ��������FrFT�Ĺ���,���ȳ߶ȱ任,��FrFt,���߶ȷ��任
% ͨ��������Կ���,�������߶ȱ任,Ƶ����Ľ��û��Ӱ��(���Գ�ʼƵ�ʵĹ���û��Ӱ��),
% ���Ե�Ƶб�ʵĹ�����Ӱ��,��ʵ�ĵ�Ƶб��Ϊ���ƽ������ (fs/T)
% by YSW 20140527

dt = 1 / fs;        % ��������
% t = -T/2:dt:T/2-dt; % ʱ����
t = 0:dt:T-dt; % ʱ����
N = T*fs;
% SNRdB = 0;          % �����
simType = 2;        % 1-�����г߶ȱ任�Ĵ���;2-���߶ȱ任�Ĵ���

% f = (-N/2:N/2-1)/N*fs;
f = (0:N-1)/N*fs;

% ��ɢ�߶ȱ仯
% �ο�����'2005-�����׸���Ҷ�任��ֵ�����е����ٹ�һ��-���˺�'
tb = T;
fb = fs;
S = sqrt(tb/fb);
xb = sqrt(tb*fb);

if simType==1
    ft = f;
    tt = t;
else
    tsp = 1/xb;
    tt = -xb/2:tsp:xb/2-tsp;    % �任���ʱ����
    ft = f * S;                 % �任���Ƶ����
end

% �ɴֵ�������
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
%     figure()%�����źŵ�FRFT��άͼ
%     mesh(p,ft,abs(Faf));
%     title('FRFT of Noisy Signal');
%     x1=xlabel('Order p');
%     x2=ylabel('Domain u');
%     zlabel('Amplitude');
%     set(x1,'Rotation',30);
%     set(x2,'Rotation',-30);
% ������ֵ
[~,ix] = max(abs(Faf(:)));
[row,col] = ind2sub(size(Faf),ix);
po = p(col);                   % ��������
Fafbest = frft(x,po);

uo = ft(row);                  % u��ȡֵ����
alpha = po*pi/2;
mute = -cot(alpha);            % ��Ƶб�ʹ���(�任��)
f0te = uo * csc(alpha);       % ����Ƶ�ʹ���(�任��)
% ����Ƶ�ʹ���
if simType==1
    f0e = f0te;
else
    f0e = f0te * sqrt(fs/T);
end
mue = mute * fs/T ;           % ��Ƶб�ʹ���


% figure()
% plot(ft, Fafbest);
window1=[zeros(1,row-10),ones(1,20),zeros(1,length(ft)-row-10)]';%���޵Ĵ�
Faf_cut=window1.*Fafbest;%�������׸���Ҷ����źŴ��޷����LFM�ź�
sig = Faf_cut;

% disp('[mu,mue]')
% disp([mu,mue])
% disp('[f0,f0e]')
% disp([f0,f0e])
