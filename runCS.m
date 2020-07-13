% �������㷨��CS����ģ����ǲ�����ѵ��±��������
% ���ǵĵ��������磬��ѳ����������Ū�����Ա��Լ��Ը���
% ��һ�����ʱ����֣�Խ������Խ�����ױ�����

% �㷨����
% ���裱 ����Ŀ�꺯���棨�أ����� �� �������������䣩�� ��������ʼ������������ɣ�����ѵĳ�ʼλ��
% ������Ⱥ��ģ������ά��������ָ��ʦ��������������Ȳ�����
% ���裲 ѡ����Ӧ�Ⱥ���������ÿ������λ�õ�Ŀ�꺯��ֵ���õ���ǰ�����ź���ֵ��
% ���裳 ��¼��һ�����ź���ֵ���� �� ʽ �������� �� �����ѵ�λ�ú�״̬���и��£�
% ���裴 ����λ�ú���ֵ����һ�����ź���ֵ���бȽϣ����Ϻã���ı䵱ǰ����ֵ��
% ���裵 ͨ��λ�ø��º����������ۣ���������� �Աȣ����� ���� ����ԣ������������� ��������ı䣬��֮�򲻱䡣�������õ�һ������λ�ã�����������
% ���裶 ��δ�ﵽ��������������С���Ҫ���򷵻ز��裲�����򣬼�����һ����
% ���裷 ���ȫ������λ�á�

clear
runtime = 1;

for time = 1:runtime
clc

global radar1
global radar2
global R
radar1 = [100 200 300 400 150 250 350 150 250 350 0 466 250 250 466 30];
radar2 = [0 0 0 0 50 50 50 -50 -50 -50 40 40 -300 300 -40 -20];
R = [40 40 40 40 40 40 40 40 40 40 20 20 260 277 20 30];

maxCycle = 1000;

D = 30;
N = 60;

ub=ones(1,D).*50;  % ���½� 
lb=ones(1,D).*-50;

beta = 1.5;  % ������ά����

NP = rand(N,D).*(repmat((ub-lb),[N 1])) + lb;   % Ϊÿ�������������λ��

for i = 1:N
    ObjVal(i) = calcu(NP(i,:));
end

Fitness = calculateFitness(ObjVal);
BestInd = find(ObjVal == min(ObjVal));
BestInd = BestInd(end);
GlobalBest = NP(BestInd,:);
GlobalObj = ObjVal(BestInd);  % �ҵ���õ��Ǹ�

% for r = 1:runtime

% https://ww2.mathworks.cn/matlabcentral/fileexchange/29809-cuckoo-search-cs-algorithm
    for iter = 1:maxCycle
        Ls = (gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
        for i = 1:N
            s = NP(i,:);
            % ģ����ά����
            u = randn(size(s))*Ls;
            v = randn(size(s));
            step = u./abs(v).^(1/beta);
            stepsize = 0.5*step.*(s-GlobalBest);  % ������õĽ�
            % ���ϵ��Ӱ����ۺ������ߵ�˳���̶Ⱥ������ٶ�
            % ̫�͵Ļ���������̫�ߵĻ�����ֵ������
            % �ۺϿ���0.5�����
            s = s+stepsize.*randn(size(s));
            ind = find(s>ub|s<lb);  % ||���ڱ�����|���ھ���
            % �������������������ط���Ҫ�����޸�
            s(ind) = rand(size(ind)).*(ub(ind)-lb(ind))+lb(ind);  % �������Խ��
            tempObj = calcu(s);
            if (tempObj < ObjVal(i))
                NP(i,:) = s;
                ObjVal(i) = tempObj;
                Fitness(i) = calculateFitness(ObjVal(i));
            end
        end
        
        % ��fitnessֵ��Ϊ���ʣ�����ʵ�У�Խ���ʵ�Ӧ��Խ�����ױ�����
        % randperm��https://blog.csdn.net/xuxinrk/article/details/80961657
        
        tempfitness = Fitness';
        tempfitness = repmat(tempfitness,[1,D]);
        K = rand(size(NP))>tempfitness; % ���Ǹ��߼����ʽ�����ص��Ǿ��󣬶�Ӧλ����0��1
        % �ǳ�������ǣ������ÿ�����ǵܵ��񣬲��ᷢ�ֲ����Լ�����
        % ����ͺܺ���
        % �����Ʋ⣬�Ǳ����ֺ�ĵ�����������
        % stepsize = 0.1*stepsize; % �������ˣ���΢�ƶ�һ��
            u = randn(size(NP))*Ls;
            v = randn(size(NP));
            step = u./abs(v).^(1/beta);
            stepsize = 0.01*step;  % �����Ǳ����֣�΢��������ϵ��ѡ���С
            % s = s+stepsize.*randn(size(s));
        NP = NP + stepsize.*K.*randn(size(NP));  % ����˲���randnЧ�����ܺ�
        % Խ����
        for i = 1:N
            ind = find(NP(i,:)>ub|NP(i,:)<lb);
            NP(i,ind) = rand(size(ind)).*(ub(ind)-lb(ind))+lb(ind);  % ���������Խ��
        end
                        
        tempBestInd = find(ObjVal == min(ObjVal));
        tempBestInd = tempBestInd(end);
        tempGlobalBest = NP(tempBestInd,:);
        tempGlobalObj = ObjVal(tempBestInd);  % �ҵ���õ��Ǹ�
        
        if (tempGlobalObj < GlobalObj)
            GlobalBest = tempGlobalBest;
            GlobalObj = tempGlobalObj;
        end
            
        aaaaa(iter) = GlobalObj; 
        fprintf('iteration = %d ObjVal=%g Fitness=%g\n',iter,GlobalObj,calculateFitness(GlobalObj));
    end
        storeer(time,:) = aaaaa;
    LoopBest(time,:) = GlobalBest;
end

figure (1)
a = mean(storeer,1);
% save CSdata a;
plot([1:maxCycle],a);
ylim([0,10]);

figure (2)
hold on
plot(0,0,'k*');
plot(500,0,'ks');

for i = 1:size(radar1,2)  % ��в�ĸ���
hold on
plot(radar1(i),radar2(i),'ko');
cir_plot([radar1(i),radar2(i)],R(i)); % �������̻�Բ
end
% legend('starting point','target point','threat center')


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

        
        
            
            








