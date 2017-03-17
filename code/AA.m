function [maxx,maxy,maxvalue]=AA      %蚁群算法求函数最大值的程序
ant=200; %蚂蚁数量
times=50; %蚂蚁移动次数
rou=0.8;  %信息素挥发系数
p0=0.2;  %转移概率常数
lower_1=0;  %设置搜索范围
upper_1=2; 
lower_2=0;
upper_2=2;
for i=1 : ant
    X(i,1)=(lower_1+(upper_1-lower_1)*rand);  %随机设置蚂蚁的初值位置
    X(i,2)=(lower_2+(upper_2-lower_2)*rand);
    tau(i)=fun_object([X(i,1),X(i,2)]); %第i只蚂蚁的信息量
end%随机初始每只蚂蚁的位置???
step=0.05;%网格划分单位

for t=1:times % 第t次移动
    t
    lamda=1/t; %步长系数，随移动次数增大而减少
    [tau_best(t),bestindex]=max(tau); %第t次移动的最优值及其位置
    for i=1:ant %第i只蚂蚁
        p(t,i)=(tau(bestindex)-tau(i))/tau(bestindex); %最优值与第i只蚂蚁的值的差比
%计算状态转移概率
    end
    for i=1:ant
        if p(t,i)<p0 %局部搜索小于转移概率常数
            temp1=X(i,1)+(2*rand-1)*lamda; %移动距离
            temp2=X(i,2)+(2*rand-1)*lamda;
        else %全局搜索
            temp1=X(i,1)+(upper_1-lower_1)*(rand-0.5);
            temp2=X(i,2)+(upper_2-lower_2)*(rand-0.5);
        end
        %%%%%%%%%%%%%%%%%%%%%%越界处理
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
        if fun_object([temp1,temp2])>fun_object([X(i,1),X(i,2)])% 判断蚂蚁是否移动
            X(i,1)=temp1;
            X(i,2)=temp2;
        end
    end
    for i=1:ant
        tau(i)=(1-rou)*tau(i)+fun_object([X(i,1),X(i,2)]); %更新信息量
    end
end
%         figure(2);
%         mesh(x,y,z);
%         hold on;
%         x=X(:,1);y=X(:,2);
%         plot3(x,y,eval(f),'k*')
%         hold on;
%         text(0.1,0.8,-0.1,'蚂蚁的最终分布位置')
%         xlabel('x');ylabel('y'),zlabel('f(x,y)');
    [max_value,max_index]=max(tau);
    maxx=X(max_index,1);
	maxy=X(max_index,2);
    maxvalue=fun_object([X(max_index,1),X(max_index,2)]);
end