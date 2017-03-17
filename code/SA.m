function [X,resEnd]=SA(X,ObjFun,ArriseNew,iter,zero)
	[ra,co]=size(X);
	RES=[-ObjFun(X)];  %每次迭代后的结果
	temperature=30;      %初始温度
	if nargin==3
        zero=1e-2;
        iter=50;               %内部蒙特卡洛循环迭代次数
    end
	if nargin==4
        zero=1e-2;
    end

% 	h=waitbar(0,'SAing....');
	while temperature>zero    %停止迭代温度
        for i=1:iter     %多次迭代扰动，一种蒙特卡洛方法，温度降低之前多次实验
            preRes=-ObjFun(X);         %目标函数计算结果
            tmpX=ArriseNew(X);      %产生随机扰动
            newRes=-ObjFun(tmpX);     %计算新结果
            if(isnan(newRes))
                continue;
            end

            delta_e=newRes-preRes;  %新老结果的差值，相当于能量
            if delta_e<0        %新结果好于旧结果，用新路线代替旧路线
                X=tmpX;
            else                        %温度越低，越不太可能接受新解；新老距离差值越大，越不太可能接受新解
                if exp(-delta_e/temperature)>rand() %以概率选择是否接受新解 p=exp(-ΔE/T)
                    X=tmpX;      %可能得到较差的解
                end
            end
        end
        RES=[RES -ObjFun(X)];
        temperature=temperature*0.99   %温度不断下降
%            waitbar((log(temperature/(100*co))/log(0.99))/(log(zero/(100*co))/log(0.99)),h,sprintf('Now Temperature:%.2f',temperature));
        end
%         close(h)
%         plot(RES);
        resEnd=RES(end);
    end