function y = lwb_chirp(f0,B,Tc,fs)
t = 0:1/fs:Tc - 1/fs;
k = B/Tc;
y = exp(1i*2*pi*f0*t+1i*k*pi*t.^2);
end