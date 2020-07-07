% ө����㷨
% ө��治���Ա�����һ��ө��潫������������������ө���;
% �����������ǵ����ȳ����ȣ������κ�����ө��棬����ô������ө��汻������������������һ��(ȫ������)
% Ȼ�����������������������Ӷ�����;���û�б�һ��������ө��������ө���
% ��������ƶ����ֲ�������������Ӧ��Ŀ�꺯����ϵ������
% ���ԣ���Ҫ�ı��Ǽ������Ⱥ������ȣ����ǲ�����ObjVal�йأ�Ҳ��ѿ��������й�

clear
clc

global radar1
global radar2
global R
radar1 = [100 200 300 400 150 250 350 150 250 350 0 466 250 250 466 30];
radar2 = [0 0 0 0 50 50 50 -50 -50 -50 40 40 -300 300 -40 -20];
R = [40 40 40 40 40 40 40 40 40 40 20 20 260 277 20 30];

runtime=1;
maxCycle = 1000;

D = 30;
N = 60;  

ub=ones(1,D).*50;  % ���½�
lb=ones(1,D).*-50;

L = max(ub)-min(lb);
gama = 1/sqrt(L);  % ������˥��������ȡ0˵���ɱ�����ө��淢�֣����еľ��������ţ�PSO��
                                 % ȡ����˵��ȫ�����ӣ��˻�Ϊȫ�������
alpha = 0.01*L;  % ��������˶�������̫���𵴣�̫С����ֲ������߿���ͨ��������������̬�仯
% ����������������

NP = rand(N,D).*(repmat((ub-lb),[N 1])) + lb;   

for i = 1:N
    ObjVal(i) = calcu(NP(i,:));
end

Fitness = calculateFitness(ObjVal);

BestInd = find(ObjVal == min(ObjVal));
BestInd = BestInd(end);
GlobalBest = NP(BestInd,:);
GlobalObj = ObjVal(BestInd);

for r = 1:runtime
    for iter = 1:maxCycle
        for i = 1:N
            for j = 1:N
                if (i~=j)  % ȡ��Ϊ~
                    if (ObjVal(j)<ObjVal(i))  % j��iҪ���ã�i����j�ƶ�
                        dist = sqrt(sum(NP(i,:)-NP(j,:)).^2);
                        attr = exp(-(gama*dist^2));  % ������
                        NP(i,:) = NP(i,:) + attr*(NP(j,:)-NP(i,:)) + rand*(rand-0.5)*alpha;
                        for k=1:D
                            if (NP(i,k)>ub(k)||NP(i,k)<lb(k))
                                NP(i,k) = rand;
                            end
                        end
                        ObjVal(i) = calcu(NP(i,:));
                    end
                end
            end
        end % �����ϣ��������Ǹ�Ӧ�ò�������ө����ƶ������Է����������������
%         BestInd = find(ObjVal == min(ObjVal));
%         BestInd = BestInd(end);
        NP(BestInd,:) = NP(BestInd,:) + rand(1,D).*(rand(1,D)-0.5)*alpha;
        for k=1:D
        	if (NP(BestInd,k)>ub(k)||NP(BestInd,k)<lb(k))
            	NP(BestInd,k) = rand;
        	end
        end
        ObjVal(BestInd) = calcu(NP(BestInd,:));    
        
        BestInd = find(ObjVal == min(ObjVal));
        BestInd = BestInd(end);
        GlobalBest = NP(BestInd,:);
        GlobalObj = ObjVal(BestInd);
        
        aaaaa(iter) = GlobalObj; 
        fprintf('iteration = %d ObjVal=%g\n',iter,GlobalObj);
    end
end

% storeer(r,:) = aaaaa;

% 
% figure (1)
% a = mean(storeer);
% plot(a)

figure (2)
hold on
plot(0,0,'k*');
plot(500,0,'ks');

for i = 1:size(radar1,2)  % ��в�ĸ���
hold on
plot(radar1(i),radar2(i),'ko');
cir_plot([radar1(i),radar2(i)],R(i)); % �������̻�Բ
end
legend('starting point','target point','threat center')


axis equal  % �������᳤�ȵ�λ��ͬ
axis([-100,620,-400,400])

hold off

for i = 1:(D-1)
    hold on
    plot([500/(D+1)*i,500/(D+1)*(i+1)],[GlobalBest(i),GlobalBest(i+1)],'LineWidth',2);
    % ����·��
end
hold on
plot([0,500/(D+1)*(1)],[0,GlobalBest(1)],'LineWidth',2); % �����յ�
plot([500/(D+1)*D,500],[GlobalBest(D),0],'LineWidth',2);
                        
                        
                        
% ��������֩��ﻹ��   
% û��̰��ѡ�񣬿��ܲ�����
                        
                        
                        
                        
                    

