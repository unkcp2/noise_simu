function result = SNR_FRFT(reciv,fs,Tdata)

[Faf2,p,Faf_sig] = FRFT_LFM_para(reciv,fs,Tdata);
sig = (frft(Faf_sig,-p))';  
sigpower = sum(abs(sig).^2)/length(sig);
noise2 = real(reciv - sig);
noipower = sum(abs(noise2).^2)/length(noise2);
result=10*log10(sigpower/noipower);