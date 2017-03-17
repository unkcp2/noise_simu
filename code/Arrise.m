function X=Arrise(x)
%x取[0,2]之间值
p1 = 2*rand();
p2 = 2*rand();
while x(1)==p1
        p1=floor(2*rand());   
end
while x(2)==p2
        p2=floor(2*rand());   
end
    X(1)=p1;
    X(2)=p2;
end