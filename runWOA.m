% ��Ⱥ�㷨��ģ����Ǿ�Ⱥ��ʳ��Ⱥ�Ĺ���
% Ϊ����ץ������Ⱥ�������ݽ���Ⱥ��Χ����������ˮ��
% �³�������������ʽ�����ģ�ּ�������Ⱥ���ܶ�
% ����Ⱥ�㷨�����ƵĲ���
% ������Ⱥ�㷨���в�ͬ��ͨ�����ʣ�0.5����ѡ����ʹ������ʽ��Χ������ֱ�Ӱ�Χ
% ��ͨ������|A|���������ھֲ�Ѱ�ţ�������ȫ������

% �㷨���̣�
% ��ʼ����������Ӧֵ��ѡ��ȫ������
% for ����������
%     for ÿ�����壺
%         ����a,A,C,l,p����
%         if (p<0.5)
%             if (|A|<1)
%                 ʹ��ֱ�Ӱ�Χ����
%             elseif (|A|>=1)
%                     ѡ��һ���������
%                     ���øø������
%             end
%         else
%             ����������Χ����
%         end
%     end
%     ���Խ�磬������Ӧֵ������ȫ������
% end

clear
clc

global radar1
global radar2
global R
radar1 = [100 200 300 400 150 250 350 150 250 350 0 466 250 250 466 30];
radar2 = [0 0 0 0 50 50 50 -50 -50 -50 40 40 -300 300 -40 -20];
R = [40 40 40 40 40 40 40 40 40 40 20 20 260 277 20 30];

r=1;

maxCycle = 1000;
D = 30;
N = 60;

ub=ones(1,D).*50;  % ���½�
lb=ones(1,D).*-50;

% WG for whales group
WG = rand(N,D).*(repmat((ub-lb),[N 1])) + lb;  

for i = 1:N
    ObjVal(i) = calcu(WG(i,:));  % ����objvalֵ�����ۺ�������ԽСԽ��
end
Fitness = calculateFitness(ObjVal); % ����Fitness��Fitness����϶ȣ�Խ��Խ���

ind = find(Fitness == max(Fitness));
ind = ind(end); 
GlobalBest = WG(ind,:);  % �ҵ�ȫ������
GlobalBestObjVal = ObjVal(ind);

for iter = 1:maxCycle
    a=2-iter*((2)/maxCycle); 
    for i = 1:N
        b = 1;
        A = 2*a*rand - a;
        C = 2*rand;
        l = rand*2-1;
        p = rand;  % ��ÿ�����壬����һ���ĸ��ʣ���������θ��¡��Ҷ�ͬһ�����壬ʹ��ͬһ����
        for j = 1:D
            if (p<0.5)
                if (abs(A)<1)
                    DP = abs(C*GlobalBest(j)-WG(i,j));
                    WG(i,j) = GlobalBest(j) - A*DP;
                else
                    neighbour = fix(N*rand)+1;
                    while(neighbour == i)
                        neighbour = fix(N*rand)+1;
                    end
                    DP = abs(C*WG(neighbour,j)-WG(i,j));
                    WG(i,j) = WG(neighbour,j) - A*DP;
                end
            else
                DP = abs(GlobalBest(j)-WG(i,j));
                WG(i,j) = DP*exp(b*l)*cos(2*pi*l) + GlobalBest(j);
            end
        end
    end
    for i = 1:N
    	% ����
    	repair = (ub-lb).*(rand(1,D))+lb;
    	ind = find(WG(i,:)>ub);
    	WG(i,ind) = repair(ind);
    	ind = find(WG(i,:)<lb);
    	WG(i,ind) = repair(ind); 
    	ObjVal(i) = calcu(WG(i,:));  % ����objvalֵ�����ۺ�������ԽСԽ��
    	Fitness = calculateFitness(ObjVal(i)); % ����Fitness��Fitness����϶ȣ�Խ��Խ���
    end    
    ind = find(Fitness == max(Fitness));
    ind = ind(end); 
    if (ObjVal(ind) < GlobalBestObjVal)
        GlobalBest = WG(ind,:);  % �ҵ�ȫ������
        GlobalBestObjVal = ObjVal(ind);
    end
    aaaaa(iter) = GlobalBestObjVal;  
    fprintf('iteration = %d ObjVal=%g\n',iter,GlobalBestObjVal);  % ��¼��������
end
storeer(r,:) = aaaaa;  % r���㷨�����д�����������ƽ��ֵͼ���Ƚ�����
% Ӧ�û���һ��ѭ��������ѭ��ִ���㷨

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
for i = 1:(D-1)
    hold on
    plot([500/(D+1)*i,500/(D+1)*(i+1)],[GlobalBest(i),GlobalBest(i+1)],'LineWidth',2);
    % ����·��
end
hold on
plot([0,500/(D+1)*(1)],[0,GlobalBest(1)],'LineWidth',2); % �����յ�
plot([500/(D+1)*D,500],[GlobalBest(D),0],'LineWidth',2);













