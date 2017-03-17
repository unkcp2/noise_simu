function [Result,OnLine,OffLine,MinMaxMeanAdapt]=PA(SwarmSize,ParticleSize,ParticleScope,IsStep,IsDraw,LoopCount,IsPlot)
%function [Result,OnLine,OffLine,MinMaxMeanAdapt]=PSO_Stand(SwarmSize,ParticleSize,ParticleScope,InitFunc,StepFindFunc,AdaptFunc,IsStep,IsDraw,LoopCount,IsPlot)
%功能描述：一个循环n次的PSO算法完整过程，返回这次运行的最小与最大的平均适应度,以及在线性能与离线性能
%[Result,OnLine,OffLine,MinMaxMeanAdapt]=PsoProcess(SwarmSize,ParticleSize,ParticleScope,InitFunc,StepFindFunc,AdaptFunc,IsStep,IsDraw,LoopCount,IsPlot)
%输入参数：SwarmSize:种群大小的个数
%输入参数：ParticleSize：一个粒子的维数
%输入参数：ParticleScope:一个粒子在运算中各维的范围；
%　　　　　　　　 ParticleScope格式:
%　　　　　　　　　　 3维粒子的ParticleScope格式:
%　　　　　　　　　　　　　　　　　　　　　　　　　　[x1Min,x1Max
%　　　　　　　　　　　　　　　　　　　　　　　　　　 x2Min,x2Max
%　　　　　　　　　　　　　　　　　　　　　　　　　　 x3Min,x3Max]
%
%输入参数:InitFunc:初始化粒子群函数
%输入参数:StepFindFunc:单步更新速度，位置函数
%输入参数：AdaptFunc：适应度函数
%输入参数：IsStep：是否每次迭代暂停；IsStep＝0，不暂停，否则暂停。缺省不暂停
%输入参数：IsDraw：是否图形化迭代过程；IsDraw＝0，不图形化迭代过程，否则，图形化表示。缺省不图形化表示
%输入参数：LoopCount：迭代的次数；缺省迭代100次
%输入参数：IsPlot：控制是否绘制在线性能与离线性能的图形表示;IsPlot=0,不显示；
%　　　　　　　　　　　　　　　　                          IsPlot=1；显示图形结果。缺省IsPlot=1
%返回值：Result为经过迭代后得到的最优解
%返回值：OnLine为在线性能的数据
%返回值：OffLine为离线性能的数据
%返回值：MinMaxMeanAdapt为本次完整迭代得到的最小与最大的平均适应度


%容错控制
if nargin<3
%if nargin<4
    error('输入的参数个数错误。')
end

[row,colum]=size(ParticleSize);
if row>1||colum>1
    error('输入的粒子的维数错误，是一个1行1列的数据。');
end
[row,colum]=size(ParticleScope);
if row~=ParticleSize||colum~=2
    error('输入的粒子的维数范围错误。');
end

%设置缺省值
if nargin<4
%if nargin<7
    IsPlot=1;
    LoopCount=100;
    IsStep=0;
    IsDraw=0;
%elseif nargin<8
elseif nargin<5
    IsPlot=1;
    IsDraw=0;
    LoopCount=100;
%elseif nargin<9
elseif nargin<6
    LoopCount=100;
    IsPlot=1;
%elseif nargin<10
elseif nargin<7
    IsPlot=1;
end

%初始化种群
[ParSwarm,OptSwarm]=InitSwarm(SwarmSize,ParticleSize,ParticleScope);

%在测试函数图形上绘制初始化群的位置
if IsDraw~=0
    if 1==ParticleSize
        for ParSwarmRow=1:SwarmSize
            plot([ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,1)],[ParSwarm(ParSwarmRow,3),0],'r*-','markersize',8);
            text(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,3),num2str(ParSwarmRow));%在图形中加注释
        end
    end
    if 2==ParticleSize
        for ParSwarmRow=1:SwarmSize
            stem3(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,2),ParSwarm(ParSwarmRow,5),'r.','markersize',8);%绘制3D图形
        end
    end
end

%暂停让抓图
if IsStep~=0
    disp('开始迭代，按任意键：')
    pause
end

%开始更新算法的调用
for k=1:LoopCount
    %显示迭代的次数：
    disp('----------------------------------------------------------')
    TempStr=sprintf('第 %g 次迭代',k);
    disp(TempStr);
    disp('----------------------------------------------------------')
    
    %调用一步迭代的算法
    %[ParSwarm,OptSwarm]=StepFindFunc(ParSwarm,OptSwarm,AdaptFunc,ParticleScope,0.95,0.4,LoopCount,k);
    [ParSwarm,OptSwarm]=BaseStepPso(ParSwarm,OptSwarm,ParticleScope,0.95,0.4,LoopCount,k);
    
    %在目标函数的图形上绘制2维以下的粒子的新位置
    if IsDraw~=0
        if 1==ParticleSize
            for ParSwarmRow=1:SwarmSize
                plot([ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,1)],[ParSwarm(ParSwarmRow,3),0],'r*-','markersize',8);
                text(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,3),num2str(ParSwarmRow));
            end
        end
        
        if 2==ParticleSize
            for ParSwarmRow=1:SwarmSize
                stem3(ParSwarm(ParSwarmRow,1),ParSwarm(ParSwarmRow,2),ParSwarm(ParSwarmRow,5),'r.','markersize',8);
            end
        end
    end
    
    XResult=OptSwarm(SwarmSize+1,1:ParticleSize);%存取本次迭代得到的全局最优值
    YResult=AdaptFunc(XResult);                  %计算全局最优值对应的粒子的适应度值
    if IsStep~=0
        %XResult=OptSwarm(SwarmSize+1,1:ParticleSize);
        %YResult=AdaptFunc(XResult);
        str=sprintf('%g 步迭代的最优目标函数值 %g',k,YResult);
        disp(str);
        disp('下次迭代，按任意键继续');
        pause
    end
    
    %记录每一步的平均适应度
    MeanAdapt(1,k)=mean(ParSwarm(:,2*ParticleSize+1));%mean函数为取有效值函数
end
%for循环结束标志

%记录最小与最大的平均适应度
MinMaxMeanAdapt=[min(MeanAdapt),max(MeanAdapt)];
%计算离线与在线性能
for k=1:LoopCount
    OnLine(1,k)=sum(MeanAdapt(1,1:k))/k;%求取在线性能的数据
    OffLine(1,k)=max(MeanAdapt(1,1:k)); 
end

for k=1:LoopCount
    OffLine(1,k)=sum(OffLine(1,1:k))/k;%求取离线性能的数据
end

%绘制离线性能与在线性能曲线
%subplot(m,n,p);%将图形窗口分成m行n列的子窗口，序号为p的子窗口为当前窗口
if 1==IsPlot
    subplot(1,2,1);
    %figure
    hold on
    title('离线性能曲线图')
    xlabel('迭代次数');
    ylabel('离线性能');
    grid on
    plot(OffLine);

    subplot(1,2,2);
    %figure
    hold on
    title('在线性能曲线图')
    xlabel('迭代次数');
    ylabel('在线性能');
    grid on
    plot(OnLine);
end
%记录本次迭代得到的最优值 适应度值
XResult=OptSwarm(SwarmSize+1,1:ParticleSize);
YResult=AdaptFunc(XResult);
Result=[XResult,YResult];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%适应度函数
function y=AdaptFunc(x)
%Griewan函数
%输入x,给出相应的y值,在x=(0,0,…,0)处有全局极小点0.
%编制人：Jeary
%编制日期：2010.12.12
[row,col]=size(x);
if row>1
    error('适应度函数：输入的参数错误');
end
% y1=1/4000*sum(x.^2);
% y2=1;
% for h=1:col
%     y2=y2*cos(x(h)/sqrt(h));
% end
% y=y1-y2+1;
% y=-y;

h = 1;
load ReciveData.mat
yout     = sr(x(1),x(2),h,rec);
y = SNR_M2M4(ks,kv,yout);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%初始化粒子群函数
function [ParSwarm,OptSwarm]=InitSwarm(SwarmSize,ParticleSize,ParticleScope)
%功能描述：初始化粒子群，限定粒子群的位置以及速度在指定的范围内


%容错控制  nargin和nargout表示该函数的输入\输出个数
%if nargin~=4
if nargin~=3
    error('粒子群初始化：输入的参数个数错误。')
end
if nargout<2
    error('粒子群初始化：输出的参数的个数太少，不能保证以后的运行。');
end

[row,colum]=size(ParticleSize);
if row>1||colum>1
    error('粒子群初始化：输入的粒子的维数错误，是一个1行1列的数据。');
end
[row,colum]=size(ParticleScope);
if row~=ParticleSize||colum~=2
    error('粒子群初始化：输入的粒子的维数范围错误。');
end

%初始化粒子群矩阵
%初始化粒子群矩阵，全部设为[0-1]随机数
%rand('state',0);
ParSwarm=rand(SwarmSize,2*ParticleSize+1);%初始化位置 速度 历史优化值

%对粒子群中位置,速度的范围进行调节
for k=1:ParticleSize
    ParSwarm(:,k)=ParSwarm(:,k)*(ParticleScope(k,2)-ParticleScope(k,1))+ParticleScope(k,1);%调节速度，使速度与位置的范围一致
    ParSwarm(:,ParticleSize+k)=ParSwarm(:,ParticleSize+k)*(ParticleScope(k,2)-ParticleScope(k,1))+ParticleScope(k,1);
end

%对每一个粒子计算其适应度函数的值
for k=1:SwarmSize
    ParSwarm(k,2*ParticleSize+1)=AdaptFunc(ParSwarm(k,1:ParticleSize));%计算每个粒子的适应度值
end

%初始化粒子群最优解矩阵
OptSwarm=zeros(SwarmSize+1,ParticleSize);
%粒子群最优解矩阵全部设为零
[maxValue,row]=max(ParSwarm(:,2*ParticleSize+1));
%寻找适应度函数值最大的解在矩阵中的位置(行数)
OptSwarm=ParSwarm(1:SwarmSize,1:ParticleSize);
OptSwarm(SwarmSize+1,:)=ParSwarm(row,1:ParticleSize);%将适应度值最大的粒子的位置最为全局粒子的最优值

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%基本的粒子群算法的单步更新位置,速度的算法函数
function [ParSwarm,OptSwarm]=BaseStepPso(ParSwarm,OptSwarm,ParticleScope,MaxW,MinW,LoopCount,CurCount)

%输入参数：ParSwarm:粒子群矩阵，包含粒子的位置，速度与当前的目标函数值
%输入参数：OptSwarm：包含粒子群个体最优解与全局最优解的矩阵
%输入参数：ParticleScope:一个粒子在运算中各维的范围；
%输入参数：AdaptFunc：适应度函数
%输入参数：AdaptFunc：适应度函数
%输入参数：MaxW  MinW：惯性权重(系数)的最大值与最小值
%输入参数：CurCount：当前迭代的次数
%返回值：含意同输入的同名参数

%容错控制
%if nargin~=8  %输入容错
if nargin~=7  %输入容错
    error('粒子群迭代：输入的参数个数错误。')
end
if nargout~=2  %输出容错
    error('粒子群迭代：输出的个数太少，不能保证循环迭代。')
end

%开始单步更新的操作
%标准粒子群算法的变形
%*********************************************
%*****更改下面的代码，可以更改惯性因子的变化*****
%---------------------------------------------------------------------
%线形递减策略
w=MaxW-CurCount*((MaxW-MinW)/LoopCount);
%---------------------------------------------------------------------
%w固定不变策略
%w=0.7;
%---------------------------------------------------------------------
%参考文献：陈贵敏，贾建援，韩琪，粒子群优化算法的惯性权值递减策略研究，西安交通大学学报，2006，1
%w非线形递减，以凹函数递减
%w=(MaxW-MinW)*(CurCount/LoopCount)^2+(MinW-MaxW)*(2*CurCount/LoopCount)+MaxW;
%---------------------------------------------------------------------
%w非线形递减，以凹函数递减
%w=MinW*(MaxW/MinW)^(1/(1+10*CurCount/LoopCount));
%*****更改上面的代码，可以更改惯性因子的变化*****
%*********************************************

%得到粒子群群体大小以及一个粒子维数的信息
[ParRow,ParCol]=size(ParSwarm);
%得到粒子的维数
ParCol=(ParCol-1)/2;
SubTract1=OptSwarm(1:ParRow,:)-ParSwarm(:,1:ParCol);%求解出历史最优值与当前位置的差值

%*********************************************
%*****更改下面的代码，可以更改c1,c2的变化*****
c1=2;
c2=2;
%---------------------------------------------------------------------
%con=1;
%c1=4-exp(-con*abs(mean(ParSwarm(:,2*ParCol+1))-AdaptFunc(OptSwarm(ParRow+1,:))));
%c2=4-c1;
%----------------------------------------------------------------------
%*****更改上面的代码，可以更改c1,c2的变化*****
%*********************************************
%完成一次粒子位置 速度 最优值的更新迭代
for row=1:ParRow
    SubTract2=OptSwarm(ParRow+1,:)-ParSwarm(row,1:ParCol);%计算出全局最优值与当前该粒子位置的差值
    %速度更新公式
    TempV=w.*ParSwarm(row,ParCol+1:2*ParCol)+c1*unifrnd(0,1).*SubTract1(row,:)+c2*unifrnd(0,1).*SubTract2;
    %限制速度的代码
    for h=1:ParCol
        if TempV(:,h)>ParticleScope(h,2)
            TempV(:,h)=ParticleScope(h,2);
        end
        if TempV(:,h)<-ParticleScope(h,2)
            TempV(:,h)=-ParticleScope(h,2)+1e-10;%加1e-10防止适应度函数被零除
        end
    end
    %更新该粒子速度值
    ParSwarm(row,ParCol+1:2*ParCol)=TempV;
    %*********************************************
    %*****更改下面的代码，可以更改约束因子的变化*****
    %---------------------------------------------------------------------
    %a=1;%约束因子
    %---------------------------------------------------------------------
    a=0.729;%约束因子
    %*****更改上面的代码，可以更改约束因子的变化*****
    %*********************************************
    %位置更新公式
    TempPos=ParSwarm(row,1:ParCol)+a*TempV;
    %限制位置范围的代码
    for h=1:ParCol
        if TempPos(:,h)>ParticleScope(h,2)
            TempPos(:,h)=ParticleScope(h,2);
        end
        if TempPos(:,h)<=ParticleScope(h,1)
            TempPos(:,h)=ParticleScope(h,1)+1e-10;%加1e-10防止适应度函数被零除
        end
    end
    %更新该粒子位置值
    ParSwarm(row,1:ParCol)=TempPos;
    
    %计算每个粒子的新的适应度值
    ParSwarm(row,2*ParCol+1)=AdaptFunc(ParSwarm(row,1:ParCol));
    if ParSwarm(row,2*ParCol+1)>AdaptFunc(OptSwarm(row,1:ParCol))
        OptSwarm(row,1:ParCol)=ParSwarm(row,1:ParCol);
    end
end
%for循环结束

%寻找适应度函数值最大的解在矩阵中的位置(行数)，进行全局最优值的改变 
[maxValue,row]=max(ParSwarm(:,2*ParCol+1));
if AdaptFunc(ParSwarm(row,1:ParCol))>AdaptFunc(OptSwarm(ParRow+1,:))
    OptSwarm(ParRow+1,:)=ParSwarm(row,1:ParCol);
end