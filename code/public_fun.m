function public_fun()
global fs Tsyn Tdata T_proctective f_syn_start B_syn f_data_start B_data 
% fs = 4e5;           %������400KHz
fs = 100000;           %������60KHz
Tsyn = 1;           %ͬ���ź�1s
% Tdata = 0.02048;     %���ݳ���ʱ��
Tdata = 0.05;     %���ݳ���ʱ��
% T_proctective = 0.02048;      %�������
T_proctective = 0.05;      %�������
f_syn_start = 4e3;  %ͬ���ź�ɨƵ��ʼֵ
% f_syn_start = 24000;  %ͬ���ź�ɨƵ��ʼֵ
B_syn = 4e3;    %ͬ���źŴ���

f_data_start = 4e3; %���ݶ���ʼƵ��
% f_data_start =24000; %���ݶ���ʼƵ��
B_data = 4e3;   %���ݶ��źŴ���

end