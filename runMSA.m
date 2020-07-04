% Moth Search algorithm������Ⱥ�㷨��ģ����Ƕ��ӵ�������
% ������Ⱥ�ֳ������飬��һ���������ڶ������Զ
% ÿ�ζ���Ҫ�Զ���Ⱥ�������е�ɱʱ��
% ���Զ�ģ��ÿ���㷨�����ѡ��һ����������һ����Խ��best��һ���ǲ�Խ��best
% �����ģ���������߷������Ź�ԴתȦȦ

% �㷨���̣�
% ��ʼ��������Ⱥ��NP�����ò���Smax�����ÿ�ο����󲽳������£�һ��ָ�����ӣ�ͨ��Ϊ1.5������������phy
% ������Ӧֵfitness����NP����fitness����
% for ����������
%     for 1 to N/2�� �����������������ߣ�N������
%         �������
%     end
%     for N/2+1:N�� �Բ���������д󲽿�
%         if rand>0.5:
%             ��󲽿�
%         else
%             �󲽿�
%         end
%     end
%     ����fitness������fitness����
% end

% �������򣬿���sortrows()����ÿһ�п������壬��ĳһ��Ϊ��׼
% ��������Ҫ��һ�У���fitness��ObjVal

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

Smax = 15;  % 5̫С��50̫��10~20����õ�ѡ��
beta = 2;   % beta��2�����
phy = (1+sqrt(5))/2;
% ����gamma������ֱ��y = gamma(x)���ɣ���������

NP = rand(N,D).*(repmat((ub-lb),[N 1])) + lb;  

for i = 1:N
    NP(i,D+1) = calcu(NP(i,1:D));  % ����objvalֵ�����ۺ�������ԽСԽ��
end

% Fitness = calculateFitness(ObjVal); % ����Fitness��Fitness����϶ȣ�Խ��Խ���
% ֱ����ObjVal�������

NP = sortrows(NP,D+1);  % ����D+1ά��������

for r = 1:runtime
    for iter = 1:maxCycle
        a = Smax/(iter^2);
        for i = 1:N/2
            s = rand+10;  % ��ʽ���һ��������ֻ˵����Ӧ�ô���0������ȡrand+(5,10)���պ�
            Ls = (beta-1)*gamma(beta - 1)*sin(pi*(beta-1)/2)/pi*(s^beta);
            % �öೣ�������������ȥ�����ټ�����
            for j = 1:D
                NP(i,j) = NP(i,j) + a*Ls;
            end
        end
        for i = N/2+1:N
            if (rand>0.5)
                for j = 1:D
                    NP(i,j) = rand * (NP(i,j) + phy * (NP(1,j) - NP(i,j)));
                end
            else
                for j = 1:D
                    NP(i,j) = rand * (NP(i,j) + (1/phy) * (NP(1,j) - NP(i,j)));
                end
            end
        end
        for i = 1:N
    	% ����
            repair = (ub-lb).*(rand(1,D))+lb;
            ind = find(NP(i,1:D)>ub);
            NP(i,ind) = repair(ind);
            ind = find(NP(i,1:D)<lb);
            NP(i,ind) = repair(ind); 
            NP(i,D+1) = calcu(NP(i,1:D));
        end  
        NP = sortrows(NP,D+1);  % ����D+1ά��������
        aaaaa(iter) = NP(1,D+1); 
        fprintf('iteration = %d ObjVal=%g\n',iter,NP(1,D+1));
    end
end

storeer(r,:) = aaaaa;

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
    plot([500/(D+1)*i,500/(D+1)*(i+1)],[NP(1,i),NP(1,i+1)],'LineWidth',2);
    % ����·��
end
hold on
plot([0,500/(D+1)*(1)],[0,NP(1,1)],'LineWidth',2); % �����յ�
plot([500/(D+1)*D,500],[NP(1,D),0],'LineWidth',2);
            
        








