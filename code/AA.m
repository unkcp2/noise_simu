function [maxx,maxy,maxvalue]=AA      %��Ⱥ�㷨�������ֵ�ĳ���
ant=200; %��������
times=50; %�����ƶ�����
rou=0.8;  %��Ϣ�ػӷ�ϵ��
p0=0.2;  %ת�Ƹ��ʳ���
lower_1=0;  %����������Χ
upper_1=2; 
lower_2=0;
upper_2=2;
for i=1 : ant
    X(i,1)=(lower_1+(upper_1-lower_1)*rand);  %����������ϵĳ�ֵλ��
    X(i,2)=(lower_2+(upper_2-lower_2)*rand);
    tau(i)=fun_object([X(i,1),X(i,2)]); %��iֻ���ϵ���Ϣ��
end%�����ʼÿֻ���ϵ�λ��???
step=0.05;%���񻮷ֵ�λ

for t=1:times % ��t���ƶ�
    t
    lamda=1/t; %����ϵ�������ƶ��������������
    [tau_best(t),bestindex]=max(tau); %��t���ƶ�������ֵ����λ��
    for i=1:ant %��iֻ����
        p(t,i)=(tau(bestindex)-tau(i))/tau(bestindex); %����ֵ���iֻ���ϵ�ֵ�Ĳ��
%����״̬ת�Ƹ���
    end
    for i=1:ant
        if p(t,i)<p0 %�ֲ�����С��ת�Ƹ��ʳ���
            temp1=X(i,1)+(2*rand-1)*lamda; %�ƶ�����
            temp2=X(i,2)+(2*rand-1)*lamda;
        else %ȫ������
            temp1=X(i,1)+(upper_1-lower_1)*(rand-0.5);
            temp2=X(i,2)+(upper_2-lower_2)*(rand-0.5);
        end
        %%%%%%%%%%%%%%%%%%%%%%Խ�紦��
        if temp1<lower_1
            temp1=lower_1;
        end
        if temp1>upper_1
            temp1=upper_1;
        end
        if temp2<lower_2
            temp2=lower_2;
        end
        if temp2>upper_2
            temp2=upper_2;
        end
        %%%%%%%%%%%%%%%%%%%%%%%
        if fun_object([temp1,temp2])>fun_object([X(i,1),X(i,2)])% �ж������Ƿ��ƶ�
            X(i,1)=temp1;
            X(i,2)=temp2;
        end
    end
    for i=1:ant
        tau(i)=(1-rou)*tau(i)+fun_object([X(i,1),X(i,2)]); %������Ϣ��
    end
end
%         figure(2);
%         mesh(x,y,z);
%         hold on;
%         x=X(:,1);y=X(:,2);
%         plot3(x,y,eval(f),'k*')
%         hold on;
%         text(0.1,0.8,-0.1,'���ϵ����շֲ�λ��')
%         xlabel('x');ylabel('y'),zlabel('f(x,y)');
    [max_value,max_index]=max(tau);
    maxx=X(max_index,1);
	maxy=X(max_index,2);
    maxvalue=fun_object([X(max_index,1),X(max_index,2)]);
end