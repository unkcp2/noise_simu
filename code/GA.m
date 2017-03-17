 function [w1_best,w2_best]=GA  
%根据遗传算法进行参数的拟合
MAXGEN = 50;
NIND   = 100;
NVAR   = 2;         %变量维数
PRECI  = 10;        %变量的二进制位数
GGAP   = 0.9;        %代沟
%2个变量的区间
         %a b 
Areas  = [0,0;
          2,2];

FieldD = [rep(PRECI,[1,NVAR]);Areas;rep([0;0;0;0],[1,NVAR])];
Chrom  = crtbp(NIND,NVAR*PRECI);
V      = bs2rv(Chrom,FieldD);
gen             = 0;

for jj=1:1:NIND 
    %计算初始种群的目标函数值
    err = -fun_object(V(jj,:));
    J(jj,1)             = err;
end
ObjV = J;
[fun_min,fun_num] = min(ObjV);
fun_best = fun_min;
w_best(1,:) = V(fun_num,:);
w1_best     = w_best(1,1);
w2_best     = w_best(1,2);

while gen < MAXGEN;   
      gen
      FitnV=ranking(ObjV);    %分配适应度值
      Selch=select('sus',Chrom,FitnV,GGAP);    %选择
      Selch=recombin('xovsp', Selch,0.8);      %重组
      Selch=mut( Selch,0.2);                   %变异
      phen1=bs2rv(Selch,FieldD);   
      for jj=1:1:size(phen1,1)    
            err = -fun_object(phen1(jj,:));  %计算子代目标函数值
            JJ(jj,1)             = err;
      end
      ObjVSel = JJ;
      [fun_min,fun_num] = min(ObjVSel);
      if(fun_min < fun_best)
            fun_best = fun_min;
            w_best(1,:) = phen1(fun_num,:);
            w1_best     = w_best(1,1);
            w2_best     = w_best(1,2);
      end      
      
      [Chrom,ObjV] = reins(Chrom,Selch,1,1,ObjV,ObjVSel);  %重插入
      gen          = gen+1; 
      
     
end 
 
 
