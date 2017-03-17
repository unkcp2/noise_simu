function result = SNR_M2M4(ks,kv,reciv)

for L = 1:50
%         ks = mean(abs(data1).^4)/(mean(abs(data1).^2))^2;
%         kv = mean(abs(noise).^4)/(mean(abs(noise).^2))^2; 
% %         kv = 3;%在正态分布中，峰度系数是3
% 
        M2 = mean(reciv.*conj(reciv)); %2阶矩
        M4 = mean((reciv.*conj(reciv)).^2); %4阶矩
        ps1(L) = ((kv-2)*M2-sqrt((4-ks*kv)*(M2^2)+(ks+kv-4)*M4))/(ks+kv-4);
        pv1(L) = M2 - ps1(L);
end
    ps = mean(ps1);
    pv = mean(pv1);
    result = 10*log10(abs(ps/pv));