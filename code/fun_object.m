function SNR_out = fun_object(x)
h = 1;
load ReciveData.mat

% rec = resample(rec,1,4);%�������ʽ�Ϊԭ����1/4

y     = sr(x(1),x(2),h,rec);
SNR_out = SNR_M2M4(ks,kv,y);