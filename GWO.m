% GWO�������㷨
% �㷨��������alpha�ǣ�ͷ�ǣ����ź�ѡ�⣩��beta�ǣ��ڶ����Ž⣩��
% delta�ǣ��������Ž⣩��omega�ǣ�����ǰ��ֻ�ǵĲ�����
% �㷨ģ������Ⱥ��Χ�����ԡ������������Ĺ���
% ����������ͷ�Ǿ������Ž�

% �㷨���̣�
% ��ʼ����Ⱥ������⣩
% ��ʼ��a,A��C����ز�����
% ����ÿ���������Ӧֵ
% Xa=���Ž�
% Xb=�ڶ��Ž�
% Xc=�����Ž�
% while(����������
%     for ÿһ������
%         ����ÿ�������Ŀǰλ�ã�ʽ3.7��
%     end
%     ����a,A��C
%     ����ÿ���������Ӧֵ
%     �����������Ž�
%     ��������++
% end
% ͷ�Ǿ������Ž�

% �ƺ���ABCû��ʲô��ͬ���������������⣬ÿ�θ�������λ�ö���ֻ��һ��ά
% ���µĻ��Ʋ�һ��
% ȱ�㣺ÿͷ��֮��û�н���������������ֲ�����
% ��dim = 30 ,swarm_number = 30�������Ч��������

clear
clc

global radar1
global radar2
global R

radar1 = [100 200 300 400 150 250 350 150 250 350 0 466 250 250 466 30];
radar2 = [0 0 0 0 50 50 50 -50 -50 -50 40 40 -300 300 -40 -20];
R = [40 40 40 40 40 40 40 40 40 40 20 20 260 277 20 30];

% ����ͼ

dim = 30;  % ά��
max_iter = 1000;  % ��������
swarm_no = 30;    % �ǵ�����
lb_no = ones(1,dim).*-50;  % ���½�
ub_no = ones(1,dim).*50;

Alpha_pos=zeros(1,dim); % ��ʼ��3�ǡ�����������ֵ���⣬�͸ĳ�-inf
Alpha_score= inf; 

Beta_pos=zeros(1,dim);
Beta_score= inf; 

Delta_pos=zeros(1,dim);
Delta_score= inf; 

Positions = repmat((ub_no-lb_no),[swarm_no,1]);
Positions = rand(swarm_no,dim).*Positions + lb_no;  % ��ʼ��ÿֻ�����ǵ�λ��

for iter = 1:max_iter  % ��ʼ����
    for i = 1:swarm_no  % ��������Ӧֵ
        ObjVal(i) = calcu(Positions(i,:)); 
        % Fitness(i) = calculateFitness(ObjVal(i));
        
        % ��������
        
        if ObjVal(i)<Alpha_score 
            Alpha_score=ObjVal(i); % Update alpha
            Alpha_pos=Positions(i,:);
        end
        
        if ObjVal(i)>Alpha_score && ObjVal(i)<Beta_score 
            Beta_score=ObjVal(i); % Update beta
            Beta_pos=Positions(i,:);
        end
        
        if ObjVal(i)>Alpha_score && ObjVal(i)>Beta_score && ObjVal(i)<Delta_score 
            Delta_score=ObjVal(i); % Update delta
            Delta_pos=Positions(i,:);
        end
        
    end
    
    a=2-iter*((2)/max_iter);  % ���²���a
    
    for i=1:size(Positions,1)  % ����ÿ��������
        for j=1:size(Positions,2)     
                       
            r1=rand(); % r1 is a random number in [0,1]
            r2=rand(); % r2 is a random number in [0,1]
            
            A1=2*a*r1-a; % Equation (3.3)
            C1=2*r2; % Equation (3.4)
            
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j)); % Equation (3.5)-part 1
            X1=Alpha_pos(j)-A1*D_alpha; % Equation (3.6)-part 1
                       
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a; % Equation (3.3)
            C2=2*r2; % Equation (3.4)
            
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); % Equation (3.5)-part 2
            X2=Beta_pos(j)-A2*D_beta; % Equation (3.6)-part 2       
            
            r1=rand();
            r2=rand(); 
            
            A3=2*a*r1-a; % Equation (3.3)
            C3=2*r2; % Equation (3.4)
            
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j)); % Equation (3.5)-part 3
            X3=Delta_pos(j)-A3*D_delta; % Equation (3.5)-part 3             
            
            Positions(i,j)=(X1+X2+X3)/3;% Equation (3.7)
            
        end
        
        % ����һ��Խ���
        Flag4ub=Positions(i,:)>ub_no;
        Flag4lb=Positions(i,:)<lb_no;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub_no.*Flag4ub+lb_no.*Flag4lb;
    end
    fprintf('iteration = %d ObjVal=%g\n',iter,Alpha_score);  % ��¼��������
end

% ������������ʱͷ�Ǿ������Ž�

%��ͼ

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
for i = 1:(dim-1)
    hold on
    plot([500/(dim+1)*i,500/(dim+1)*(i+1)],[Alpha_pos(i),Alpha_pos(i+1)],'LineWidth',2);
    % ����·��
end
hold on
plot([0,500/(dim+1)*(1)],[0,Alpha_pos(1)],'LineWidth',2); % �����յ�
plot([500/(dim+1)*dim,500],[Alpha_pos(dim),0],'LineWidth',2);












