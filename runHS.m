% ��������
% ��һ���⿴��D������������
% ��ʼ��N���⡣������ѡ������������½⻹�Ǵ�N���������ѡһ��
% ����Ǵ�N������ѡ�����ģ�������ѡ���Ƿ����΢��
% ÿһά�������
% Ȼ�������ıȽϣ������Ƿ��滻

clear
clc

global radar1
global radar2
global R
radar1 = [100 200 300 400 150 250 350 150 250 350 0 466 250 250 466 30];
radar2 = [0 0 0 0 50 50 50 -50 -50 -50 40 40 -300 300 -40 -20];
R = [40 40 40 40 40 40 40 40 40 40 20 20 260 277 20 30];

runtime=1;
maxCycle = 2000;

D = 30;
N = 60;  

ub=ones(1,D).*50;  % ���½�
lb=ones(1,D).*-50;

L = max(ub)-min(lb);

NP = rand(N,D).*(repmat((ub-lb),[N 1])) + lb;   

for i = 1:N
    ObjVal(i) = calcu(NP(i,:));
end

HMCR = 0.875; % �����ȡֵ���ʣ������Ӱ��Ч���Ĺؼ�
PAR = 0.25;% ΢������
BAR = L*0.01; % ΢������

Fitness = calculateFitness(ObjVal);

BestInd = find(ObjVal == min(ObjVal));
BestInd = BestInd(end);
GlobalBest = NP(BestInd,:);
GlobalObj = ObjVal(BestInd);

for r = 1:runtime
    for iter = 1:maxCycle
        % ����һ���º���
        temp = zeros(1,D);
        for j = 1:D
            if (rand<HMCR)
                temp(j) = NP(fix(rand*N)+1,j);
            else
                temp(j) = lb(j) + rand*(ub(j)-lb(j)); % ���һ��
            end
            if (rand<PAR) % ΢������
                temp(j) = temp(j) + 2*BAR*rand-BAR; % ΢��
            end
        end
        tempObj = calcu(temp);
        
        BadInd = find(ObjVal == max(ObjVal));
        BadInd = BadInd(end);
        if (tempObj<ObjVal(BadInd)) % �µĺ�������
            NP(BadInd,:) = temp;
            ObjVal(BadInd) = tempObj;
        end
        
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


% ���м��죬��ķ���
% ����ÿ���滻�������ģ��������Ʋ��ǽ���ʽ�½�
% ����Ϊ������⣬�����ͱ�����ʣ���������ѡȡ���еĸ��ʺ�Ч��ǿ�˺ܶ�ܶ�
% ������Ҫ����ĵ�������������ʵ��̫����
% ������ս����Χ�������޺󣩣�����һ�㣬���ȶ�
                    







