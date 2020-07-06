% ��ֽ���
% ���졢���桢ȡ��
% ͨ�����ѡ����������ÿһά���б��죨���췽ʽ�ж��֣���Ȼ�󰴸���ѡ���Ƿ񽻲�

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
N = 60;   % �ڸ��㷨�У�N=2D��Ч�����
F = 0.5; % �������ӣ�һ����[0,2]  % ������FԽ��Խ�� % ��һ����ͨ�����Խ���飬0.5������
CR = 0.5; % ���ʾ����Ƿ񽻲�

ub=ones(1,D).*50;  % ���½�
lb=ones(1,D).*-50;

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
            for j = 1:D % Ϊÿһά��������
                p = fix(rand*N)+1;
                q = fix(rand*N)+1;
                while(q==p)
                    q = fix(rand*N)+1;
                end
                m = fix(rand*N)+1;
                while(m==q||m==p)
                    m = fix(rand*N)+1;
                end
                
                n = fix(rand*N)+1;
                while(n==q||n==p||n==m)
                    n = fix(rand*N)+1;
                end
                
                % v(j) = NP(p,j) + F*(NP(q,j)-NP(m,j));  % ���췽ʽ�кܶ�ܶ���
                
                v(j) = GlobalBest(j) + F*(NP(p,j)-NP(q,j)+NP(m,j)-NP(n,j));
                    	% ����
                if(v(j)>ub(j)||v(j)<lb(j))
                    v(j) = (ub(j)-lb(j))*rand+lb(j);
                end
                
                % ����
                if (rand>CR || fix(rand*D)+1==j)
                    u(j) = v(j);
                else
                    u(j) = NP(i,j);
                end
            end
            tempObj = calcu(u);
            if(tempObj<ObjVal(i))
                NP(i,:) = u;
                ObjVal(i) = tempObj;
            end
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
                
                
                
                
                
                
                
                
                
                
                
                
                
