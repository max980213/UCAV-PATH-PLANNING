% �����㷨��ģ������ͨ������Ѱ�����ﲢ�����ϰ���
% �����������û�����λ�ķ�����֪����,�������ǲ���һ������ķ�ʽ����������ͱ����ϰ���֮��Ĳ�ͬ��
% % ������λ��xi���ٶ�vi�������,�Թ̶���Ƶ��fmin���ɱ�Ĳ����˺�����A0���������
% �������������Ŀ����ڽ��̶����Զ�������������岨������Ƶ�ʣ��͵������巢����r����[0,1]
% ��Ȼ�����ı仯��ʽ�ж��ֵ��������㷨��, �ٶ�����A�Ǵ�һ�����ֵA0(����)�仯���̶���СֵAmin

% https://www.cnblogs.com/caoer/p/12641369.html
% ���ǳ����ֽ���������ֻ����û�н��棬�����õ������Ž�������

% Դ����ο�
% https://ww2.mathworks.cn/matlabcentral/fileexchange/74768-the-standard-bat-algorithm-ba

runtime=10;

for r = 1:runtime
clear
clc

global radar1
global radar2
global R
radar1 = [100 200 300 400 150 250 350 150 250 350 0 466 250 250 466 30];
radar2 = [0 0 0 0 50 50 50 -50 -50 -50 40 40 -300 300 -40 -20];
R = [40 40 40 40 40 40 40 40 40 40 20 20 260 277 20 30];


maxCycle = 500;

D = 30;
N = 60;

Fmin = 1;
Fmax = 4;  % Ƶ��������
f = zeros(N,1);  % ÿ�������Ƶ��
v = zeros(N,D);  % �ٶȣ���ÿһά�Ķ���һ��

A = 5;  % ����
r0 = 10; % ����
alpha = 0.97;
gamma = 1.5;  % ��������


ub=ones(1,D).*50;
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


    for iter = 1:maxCycle
        r = r0*(1-exp(-gamma*iter));
        A = alpha*A;  % ��ʼ�������ʺ�����
        for i = 1:N
        	f(i) = Fmin + (Fmax-Fmin)*rand;
        	v(i,:) = v(i,:) + (NP(i,:) - GlobalBest).*f(i);  % �ٶ�
        	temp = NP(i,:) + v(i,:);
            
            if (rand<r)
                temp = GlobalBest + 0.1*randn(1,D)*A; % randn����̬�ֲ�
            end
            
            for j = 1:D  % Խ����
                if (temp(j)>ub(j)||temp(j)<lb(j))
                    temp(j) = rand*(ub(j)-lb(j))+lb(j);
                end
            end
            
            tempObj = calcu(temp);
            
            if (tempObj<ObjVal(i) && rand>A)  % �����������������(�뵱ǰ����ȣ�
                NP(i,:) = temp;
                ObjVal(i) = tempObj;
            end
            
            if (tempObj<=GlobalObj) % ����ȫ��
                GlobalBest = temp;
                GlobalObj = tempObj;
            end
        end
        aaaaa(iter) = GlobalObj; 
        fprintf('iteration = %d ObjVal=%g\n',iter,GlobalObj);
    end
    storeer(r,:) = aaaaa;
end



 
figure (1)
a = mean(storeer);
plot([1:maxCycle],a);

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


% �����㷨
% ͦ��ģ������ö࣬�ø��ӣ�Ч��һ�㣬��������
% ������ȶ�����������ֲ�����







