% ֩����㷨��Spider Monkey Optimization��
% ���е�����ABC��GWO�Ľ��
% ������ͣ�͵�ʱ��ABC�е�trial������Ⱥ�ͻ���ѳ�С��Ⱥ��С��Ⱥ��ɢѰ��
% ÿ��С��Ⱥ����һ��LocalBest��ȫ����һ��GlobalBest
% pr��perturbation rate������ĿǰΪֹ�ı����ʣ�һ��ȡ[0.1,0.8]

% �㷨���̣�
% 1. ��ʼ��
% 2. ������Ӧֵ
% 3. ѡ��ȫ�����ź;ֲ�����
% while ������������������
%     1. ����ÿ�����ÿ��ά������ÿ��С��Ⱥ�ľֲ����ź�����������Ӧֵ��̰�ķ�����
%     ��������ʴ���pr�������ֲ����Ÿ��£�������ԭ�⣩
%     2. ����fitness����ÿ���ⱻѡ��ĸ���
%     3. ��ÿ���⣬������ѡ���Ƿ���£��������ĳ��ά������ȫ�����ź�����
%     4. ����ȫ�����ź�ÿ��СȺ��ľֲ����ţ�̰�ķ�
%     5. ���СȺ��ľֲ����ųٳ�δ���£�����СȺ�����г�Աȫ������λ��
%     ���������Ƿ����pr����������ֱ������������⣬��С��������������Ÿ��£�
%     �������ʣ�
%     6. ���ȫ�����ųٳ�û�и��£��ͽ�����Ⱥ��Ⱥ����Ϊ�����СȺ�壨2,3,4....��
%     ��Ⱥ���������ޣ����ﵽ����ʱ�Ͱ�ȫ��СȺ�����ºϲ�Ϊһ������Ȼ����¸��ֲ�����
%     ����Ҫ���ǽ����¼��������㣬����ٳ�û�и��£�
% end

clear
clc

global radar1
global radar2
global R
radar1 = [100 200 300 400 150 250 350 150 250 350 0 466 250 250 466 30];
radar2 = [0 0 0 0 50 50 50 -50 -50 -50 40 40 -300 300 -40 -20];
R = [40 40 40 40 40 40 40 40 40 40 20 20 260 277 20 30];

maxCycle = 200;
D = 60;
N = 60;
MG = N/4;  % ���СȺ����
GlobalLeader = zeros(1,D);
LocalLeader = zeros(MG,D);  % ���ÿ��СȺ��ľֲ�����
GlobalLeaderLimit = N;  % ��Ӧ����[N/2,2*N]֮��
LocalLeaderLimit = D*N; % ��������ô���õ�
GlobalLeaderCount = 0;
LocalLeaderCount = zeros(1,MG);
GroupNumber = 1;  % ��Ҳû˵�ʼ��������Ⱥ��Ĭ��һ��

ub=ones(1,D).*50;  % ���½�
lb=ones(1,D).*-50;

pr = 0.8;  % һ��ȡ[0.1,0.8]����ʵ���ⶫ���ǳ�Ӱ�������ٶ�

SM = rand(N,D).*(repmat((ub-lb),[N 1])) + lb;  % ����ÿ�����λ��

for i = 1:N
    ObjVal(i) = calcu(SM(i,:));  % ����objvalֵ�����ۺ�������ԽСԽ��
end
Fitness = calculateFitness(ObjVal); % ����Fitness��Fitness����϶ȣ�Խ��Խ���

ind = find(Fitness == max(Fitness));
ind = ind(end); 
GlobalLeader = SM(ind,:);  % �ҵ�ȫ������
GlobalLeaderObjVal = ObjVal(ind);

LocalLeaderObjVal = zeros(1,MG);
for i = 1:GroupNumber  % ��ʱ�Ȳ���������������
    ind = find(Fitness == max(Fitness(N/GroupNumber*(i-1)+1:N/GroupNumber*i)));
    ind = ind(end);
    LocalLeader(i,:) = SM(ind,:);  % Ϊÿһ��СȺ���ҵ��ֲ�����
    LocalLeaderObjVal(i) = ObjVal(ind);
end

for iter = 1:maxCycle  % ��ʼ����
    
    for k = 1:GroupNumber  % ����ÿ��СȺ
        for i = N/GroupNumber*(k-1)+1:N/GroupNumber*k  % ����Ⱥ���ÿ������
            for j = 1:D  % ����ÿһά
                if (rand>=pr)
                    range = -(N/GroupNumber*(k-1)+1 - N/GroupNumber*k);
                    neighbour = fix(N/GroupNumber*(k-1)+1 + rand*range); % �ڸ�Ⱥ�������������
                    while(neighbour==i) 
                        neighbour = fix(N/GroupNumber*(k-1)+1 + rand*range);
                    end
                    temp = SM(i,:);
                    temp(j) = SM(i,j) + rand*(LocalLeader(k,j)-SM(i,j)) + (rand-0.5)*2*(SM(neighbour,j)-SM(i,j));
                                          %
               if(temp(j)<lb(j)||temp(j)>ub(j))
                   temp(j) = rand * (ub(j)-lb(j)) + lb(j);
               end
                     %
                    tempObjVal = calcu(temp);
                    if (tempObjVal<ObjVal(i))
                        SM(i,j) = temp(j);
                        ObjVal(i) = tempObjVal;
                        Fitness(i) = calculateFitness(ObjVal(i));
                    end
                end
            end
        end
    end
    
    % �������
    fitnessSum = sum(Fitness);
    for i = 1:N
        prob(i) = Fitness(i)/fitnessSum;
    end
    
    % ������prob��ȫ�����Ÿ���ÿһ��
    
    for k = 1:GroupNumber  % ����ÿ��СȺ��
        for i = N/GroupNumber*(k-1)+1:N/GroupNumber*k % ����ÿ������
           if (prob(i)>rand)
               dim2change = fix(rand*D)+1;
               range = -(N/GroupNumber*(k-1)+1 - N/GroupNumber*k);
               neighbour = fix(N/GroupNumber*(k-1)+1 + rand*range); % �ڸ�Ⱥ�������������
               while(neighbour==i) 
                    neighbour = fix(N/GroupNumber*(k-1)+1 + rand*range);
               end
               temp = SM(i,:);
               temp(j) = SM(i,j) + rand*(GlobalLeader(j) - SM(i,j)) + (rand-0.5)*2*(SM(neighbour,j)-SM(i,j));
                       %
               if(temp(j)<lb(j)||temp(j)>ub(j))
                   temp(j) = rand * (ub(j)-lb(j)) + lb(j);
               end
                     %
               tempObjVal = calcu(temp);
               if (tempObjVal<ObjVal(i))
                   SM(i,j) = temp(j);
                   ObjVal(i) = tempObjVal;
                   Fitness(i) = calculateFitness(ObjVal(i));
               end
           end
        end
    end
    
    % ����ȫ�����ź͸���СȺ�������
    ind = find(Fitness == max(Fitness));
    ind = ind(end); 
    if (ObjVal(ind) < GlobalLeaderObjVal)
        GlobalLeader = SM(ind,:);  % ��ȫ�����ŷ�������
        GlobalLeaderObjVal = ObjVal(ind);
        GlobalLeaderCount = 0;
    else
        GlobalLeaderCount = GlobalLeaderCount+1;
    end

    for i = 1:GroupNumber  % ���¾ֲ�����
        ind = find(Fitness == max(Fitness(N/GroupNumber*(i-1)+1:N/GroupNumber*i)));
        ind = ind(end);
        if (ObjVal(ind) < LocalLeaderObjVal(i))
            LocalLeader(i,:) = SM(ind,:);  % ��ȫ�����ŷ�������
            LocalLeaderObjVal(i) = ObjVal(ind);
            LocalLeaderCount(i) = 0;
        else
            LocalLeaderCount(i) = GlobalLeaderCount(i)+1;
        end
    end
    
    % �����һ��СȺ�峤ʱ��û���£��������������ǣ�Ҫô��ȫ�����Ҫô����ȫ�����ţ������ǻع�����
    for k = 1:GroupNumber
        if (LocalLeaderCount>LocalLeaderLimit)
            LocalLeaderCount(k) = 0;
        for i = N/GroupNumber*(k-1)+1:N/GroupNumber*k % ����ÿ��СȺ����
            for j = 1:D
                if(rand>pr)
                    SM(i,j) = lb(j) + rand*(ub(j)-lb(j));
                else
                    SM(i,j)=SM(i,j)+rand*(GlobalLeader(j)-SM(i,j))+rand*(SM(i,j)-LocalLeader(k,j));
                end
                                      %
               if(SM(i,j)<lb(j)||SM(i,j)>ub(j))
                   SM(i,j) = rand * (ub(j)-lb(j)) + lb(j);
               end
                     %
            end
            ObjVal(i) = calcu(SM(i,:));
            Fitness(i) = calculateFitness(ObjVal(i));
        end
        ind = find(Fitness == max(Fitness(N/GroupNumber*(k-1)+1:N/GroupNumber*k)));
        ind = ind(end);
        LocalLeader(k,:) = SM(ind,:);  % ΪСȺ���ҵ��ֲ�����
        LocalLeaderObjVal(k) = ObjVal(ind);
        
            ind = find(Fitness == max(Fitness));
    ind = ind(end); 
    if (ObjVal(ind) < GlobalLeaderObjVal)
        GlobalLeader = SM(ind,:);  % ��ȫ�����ŷ�������
        GlobalLeaderObjVal = ObjVal(ind);
        GlobalLeaderCount = 0;
    else
        GlobalLeaderCount = GlobalLeaderCount+1;
    end
        end
    end
    
    if (GlobalLeaderCount>GlobalLeaderLimit)
        GlobalLeaderCount = 0;
        if (GroupNumber < MG)
            GroupNumber = GroupNumber + 1;
        else
            GroupNumber = 1;
        end
        for i = 1:GroupNumber  % ���¾ֲ�
            ind = find(Fitness == max(Fitness(N/GroupNumber*(i-1)+1:N/GroupNumber*i)));
            ind = ind(end);
            LocalLeader(i,:) = SM(ind,:);  % Ϊÿһ��СȺ���ҵ��ֲ�����
            LocalLeaderObjVal(i) = ObjVal(ind);
        end
    end
    fprintf('iteration = %d ObjVal=%g\n',iter,GlobalLeaderObjVal);  % ��¼��������
    aaaaa(iter) = GlobalLeaderObjVal;    
end

storeer = aaaaa;

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
    plot([500/(D+1)*i,500/(D+1)*(i+1)],[GlobalLeader(i),GlobalLeader(i+1)],'LineWidth',2);
    % ����·��
end
hold on
plot([0,500/(D+1)*(1)],[0,GlobalLeader(1)],'LineWidth',2); % �����յ�
plot([500/(D+1)*D,500],[GlobalLeader(D),0],'LineWidth',2);



% ���ۣ�Ч���պϣ����ٶȼ�������Լ��200�ε�������
    















        