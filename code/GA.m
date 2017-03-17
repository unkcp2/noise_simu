 function [w1_best,w2_best]=GA  
%�����Ŵ��㷨���в��������
MAXGEN = 50;
NIND   = 100;
NVAR   = 2;         %����ά��
PRECI  = 10;        %�����Ķ�����λ��
GGAP   = 0.9;        %����
%2������������
         %a b 
Areas  = [0,0;
          2,2];

FieldD = [rep(PRECI,[1,NVAR]);Areas;rep([0;0;0;0],[1,NVAR])];
Chrom  = crtbp(NIND,NVAR*PRECI);
V      = bs2rv(Chrom,FieldD);
gen             = 0;

for jj=1:1:NIND 
    %�����ʼ��Ⱥ��Ŀ�꺯��ֵ
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
      FitnV=ranking(ObjV);    %������Ӧ��ֵ
      Selch=select('sus',Chrom,FitnV,GGAP);    %ѡ��
      Selch=recombin('xovsp', Selch,0.8);      %����
      Selch=mut( Selch,0.2);                   %����
      phen1=bs2rv(Selch,FieldD);   
      for jj=1:1:size(phen1,1)    
            err = -fun_object(phen1(jj,:));  %�����Ӵ�Ŀ�꺯��ֵ
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
      
      [Chrom,ObjV] = reins(Chrom,Selch,1,1,ObjV,ObjVSel);  %�ز���
      gen          = gen+1; 
      
     
end 
 
 
