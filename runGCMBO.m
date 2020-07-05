% �������Ż��㷨��Monarch butterfly optimization��
% ���ڵİ汾��������̰�����ƵĸĽ��㷨
% ���㷨ģ���������land�ĵ�����Ǩ����̣������land1��land2�����������ڻ���
% land1����ceil(p*N)�����壬ceil������ȡ����p��һ���ʣ�����ÿ�����������������ȡ0.5�ɣ�
% land2�о���N-N1��
% �㷨ͬʱģ���˲��ѹ��̡�Ϊ�˱����������䣬����һ��С�ľ���ȥһ���ϵ�
% ������ԭ�㷨�У����ǲ����³����ĺû���ͳͳ�������Ľ�����㷨������̰�ķ�
% ͬʱ���������Ӧ����ͨ����������Ӧֵ������

% �㷨���̣�
% ��ʼ����ȺP������ΪN������land1��land2�ĺ���������N1��N2����������Ӧֵ
% for ����������
%     ����Ⱥ���򣬲ο������㷨��������Ⱥ��ֳ�������
%     for land1�����и��壺
%         for ��ÿһά��
%             ����ÿһά�����·����ο�Monarch butterfly optimization��ԭʼ�㷨��
%         end
%         ̰�ķ������Ƿ��������壩
%     end
%     for land2�����и��壺
%         ����dx��alpha������dx��levy���к���������Ⱥ�㷨���ֹ������������������
%         Ls = (beta-1)*gamma(beta - 1)*sin(pi*(beta-1)/2)/pi*(s^beta);
%         ֻ�ǽ��ƣ������ı��ʽ��һ������
%         for ��ÿһά��
%             ����ÿһά��ͬ���ο���ƪ����
%         end
%         �Ըø��壬������Ӧ��ʽ������һ���µ�ֵ��ģ�ⷱ�ܣ�������̰�ķ�ѡ���Ƿ���
%     end
%     ��������Ӧֵ
% end

global radar1
global radar2
global R
radar1 = [100 200 300 400 150 250 350 150 250 350 0 466 250 250 466 30];
radar2 = [0 0 0 0 50 50 50 -50 -50 -50 40 40 -300 300 -40 -20];
R = [40 40 40 40 40 40 40 40 40 40 20 20 260 277 20 30];

runtime=1;

maxCycle = 200;
D = 30;
N = 60;
p = 0.5;  %�ݶ�����land�ĸ�������һ����
N1 = ceil(p*N);
N2 = N-N1;
peri = 1;
beta = 2;
Smax = 15;
BAR = 0.75;  % butterfly adjusting rate������֪����ô����

ub=ones(1,D).*50;  % ���½�
lb=ones(1,D).*-50;

Smax = 15;
beta = 1.5;

NP = rand(N,D).*(repmat((ub-lb),[N 1])) + lb;  

for i = 1:N
    NP(i,D+1) = calcu(NP(i,1:D));  % ����objvalֵ�����ۺ�������ԽСԽ��
end

NP = sortrows(NP,D+1);  % ����D+1ά��������

for r = 1:runtime

for iter = 1:maxCycle
    for i = 1:N1  % ����land1 ��ģ��Ǩ�㣩
        tempSol = NP(i,:);
        for j = 1:D  % ����ÿһά
            if (rand*peri <= p)  % ʹ��land1�ĸ������
                neibour = fix(rand*(N1-1))+1;
                while (neibour == i)
                    neibour = fix(rand*(N1-1))+1;
                end
                tempSol(j) = NP(neibour,j);
            else
                neibour = fix(rand*(N-(N1+1)))+1;
                tempSol(j) = NP(neibour,j);
            end
        end
        tempSol(D+1) = calcu(tempSol(1:D));
        if (tempSol(D+1) < NP(i,D+1))
            NP(i,:) = tempSol;  % ̰�ķ�  ����ֻ���滻�������ϲ������Խ��
        end
    end
    alpha = Smax/(iter^2);
    for i = N1+1:N
        s = abs(normrnd(0,1));
        dx = (beta-1)*gamma(beta - 1)*sin(pi*(beta-1)/2)/pi*(s^beta);
        
        tempSol1 = NP(i,:);
        for j = 1:D
            temprand = rand;
            if (temprand<=p)
                tempSol1(j) = NP(1,j);
            else
                neibour = fix(rand*(N-(N1+1)))+1;
                while (neibour == i)
                    neibour = fix(rand*(N-(N1+1)))+1;
                end
                tempSol1(j) = NP(neibour,j);
                if (temprand>BAR)
                    tempSol1(j) = tempSol1(j)+alpha*(dx-0.5);
                end
            end
        end
        
        Cr = 0.8 + 0.2*(NP(i,D+1)-NP(1,D+1))/(NP(N,D+1)-NP(1,D+1));  % ����Ӧֵ
        tempSol2(1:D) = tempSol1(1:D).*(1-Cr) + NP(i,1:D).*Cr;
        tempSol1(D+1) = calcu(tempSol1(1:D));
        tempSol2(D+1) = calcu(tempSol2(1:D));
        if (tempSol1(D+1)<tempSol2(D+1))
            NP(i,:) = tempSol1;
        else
            NP(i,:) = tempSol2;
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
            









