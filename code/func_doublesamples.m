function s3 = func_doublesamples(sn,M);

%½µ²ÉÑù
s2    = resample(sn,1,M);
%³ß¶È»Ö¸´
s3    = sn;
 

for i = 1:length(sn)-2*M
    if mod(i,M) == 1;
       s3(i) = s2(floor(i/M)+1);
    else
       s3(i) = s3(i-1)+(s2(floor(i/M)+2) - s2(floor(i/M)+1))/M; 
    end
end
