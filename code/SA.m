function [X,resEnd]=SA(X,ObjFun,ArriseNew,iter,zero)
	[ra,co]=size(X);
	RES=[-ObjFun(X)];  %ÿ�ε�����Ľ��
	temperature=30;      %��ʼ�¶�
	if nargin==3
        zero=1e-2;
        iter=50;               %�ڲ����ؿ���ѭ����������
    end
	if nargin==4
        zero=1e-2;
    end

% 	h=waitbar(0,'SAing....');
	while temperature>zero    %ֹͣ�����¶�
        for i=1:iter     %��ε����Ŷ���һ�����ؿ��巽�����¶Ƚ���֮ǰ���ʵ��
            preRes=-ObjFun(X);         %Ŀ�꺯��������
            tmpX=ArriseNew(X);      %��������Ŷ�
            newRes=-ObjFun(tmpX);     %�����½��
            if(isnan(newRes))
                continue;
            end

            delta_e=newRes-preRes;  %���Ͻ���Ĳ�ֵ���൱������
            if delta_e<0        %�½�����ھɽ��������·�ߴ����·��
                X=tmpX;
            else                        %�¶�Խ�ͣ�Խ��̫���ܽ����½⣻���Ͼ����ֵԽ��Խ��̫���ܽ����½�
                if exp(-delta_e/temperature)>rand() %�Ը���ѡ���Ƿ�����½� p=exp(-��E/T)
                    X=tmpX;      %���ܵõ��ϲ�Ľ�
                end
            end
        end
        RES=[RES -ObjFun(X)];
        temperature=temperature*0.99   %�¶Ȳ����½�
%            waitbar((log(temperature/(100*co))/log(0.99))/(log(zero/(100*co))/log(0.99)),h,sprintf('Now Temperature:%.2f',temperature));
        end
%         close(h)
%         plot(RES);
        resEnd=RES(end);
    end