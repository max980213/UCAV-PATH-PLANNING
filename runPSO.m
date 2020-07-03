% PSO������Ⱥ�Ż��㷨����һ�ֻ�����Ⱥ������Ż��㷨��ÿ����Աѧϰ������ͻ�龭�����ı�����ģʽ
% �㷨˼�룺��Ⱥ��ÿ�����嵥����Ѱ���Ž⣬��Ϊ���弫ֵ������������������ҵ����弫ֵ���ŵ��Ǹ�
% ��Ϊȫ�����Ž⡣Ȼ�����и�������Լ��ĸ��弫ֵ��ȫ�ּ�ֵ�������Լ���λ�á�
% ���ӵ��������ԣ��ٶȺ�λ�ã�λ��Ҳ�������ƶ�����

% �ǳ����ݶ��½�������ÿ����Ҫ�Լ�Ѱ�ҷ���

% ��ʽ��
% vi = vi + c1*rand()*(pbest-xi)+c2*rand()*(gbest-xi) �����ٶȣ����䡢������֪��������֪��
% xi = xi + vi ����λ�á������ȡֵ��0��1��

% ��������ʽ�ӣ��õ���׼ʽ��
% vi = ����Сд��*vi + c1*rand()*(pbest-xi)+c2*rand()*(gbest-xi)
% ���У�����Сд��Ϊ�������ӣ��Ǹ�����w��ȫ��Ѱ������ǿ��wС���ֲ�Ѱ������ǿ
% ������ô��⣺wС��vi��ֵ��С��xi�ı仯��С->�ھֲ��

clear
clc

global radar1
global radar2
global R
% radar1 = [350 105 305 105 175 245 415 480 40 470];
% baili = size(radar1,2);
% radar2 = [200 0 -150 110 110 110 0 110 100 -50];
% R = [140 70 150 30 25 25 25 90 40 30];


radar1 = [100 200 300 400 150 250 350 150 250 350 0 466 250 250 466 30];
baili = size(radar1,2);
radar2 = [0 0 0 0 50 50 50 -50 -50 -50 40 40 -300 300 -40 -20];
R = [40 40 40 40 40 40 40 40 40 40 20 20 260 277 20 30];
%------������ʼ������----------------------------------------------
c1=1.4962;             %ѧϰ����1
c2=1.4962;             %ѧϰ����2
w=0.7298;              %����Ȩ��
runtime =1;
MaxDT=1000;            %����������
storeer = zeros(runtime,MaxDT);
Pbest = zeros(MaxDT,1);
D=60;                  %�����ռ�ά����δ֪��������
N=20;                  %��ʼ��Ⱥ�������Ŀ
ub=ones(1,D).*100; %/*lower bounds of the parameters. */
lb=ones(1,D).*-50;%/*upper bound of the parameters.*/
for r=1:runtime
    
%------��ʼ����Ⱥ�ĸ���(�����������޶�λ�ú��ٶȵķ�Χ)------------
Range = repmat((ub-lb),[N 1]);
Lower = repmat(lb, [N 1]);
Foods = rand(N,D) .* Range + Lower;  % ������ɳ�ʼλ�ú��ٶȣ�Rangeֻ������ʹ���ˣ�
x = Foods;
Foods = rand(N,D) .* Range + Lower;
v = Foods;
%------�ȼ���������ӵ���Ӧ�ȣ�����ʼ��Pi��pg----------------------
for i=1:N
    p(i)=fitness(x(i,:)); % �����Ӧֵ�������¸���ģ��
    y(i,:)=x(i,:);  % D�Ѿ���ƽ�滮��������
end
pg=x(1,:);             %pgΪȫ������
for i=2:N
    if fitness(x(i,:))<fitness(pg)
        pg=x(i,:);
    end
end  % Ѱ�ҳ�ʼȫ������
%------������Ҫѭ�������չ�ʽ���ε�����ֱ�����㾫��Ҫ��------------
for t=1:MaxDT
    for i=1:N
        v(i,:)=w*v(i,:)+c1*rand*(y(i,:)-x(i,:))+c2*rand*(pg-x(i,:));
        x(i,:)=x(i,:)+v(i,:);
        sol=x(i,:);
        % ����
        ind=find(sol<lb);
        libai = rand(1,D).*(ub-lb)+lb;
        sol(ind)=libai(ind);
        ind=find(sol>ub);
        libai = rand(1,D).*(ub-lb)+lb;
        sol(ind)=libai(ind);
        %
        x(i,:)=sol;
        if fitness(x(i,:))<p(i) % ���µ���Ӧֵ��ԭ���ıȽ�
            p(i)=fitness(x(i,:)); % ������ţ��͸���
            y(i,:)=x(i,:);
        end
        if p(i)<fitness(pg) % ����ȫ������
            pg=y(i,:);
        end
    end
    Pbest(t)=fitness(pg);
    fprintf('iteration = %d ObjVal=%g\n',t,Pbest(t));
end
%------������������
GlobalParams(r,:) = pg; % �����ֵ
storeer(r,:) = Pbest;   % �������Ӧֵ
end




% figure (1)
% apso = mean(storeer);
% plot(apso)


figure (2)
hold on
plot(0,0,'k*')
plot(500,0,'ks')

for i = 1:baili
hold on
plot(radar1(i),radar2(i),'ko');
cir_plot([radar1(i),radar2(i)],R(i));
end
legend('starting point','target point','threat center')

axis equal
%axis([-100,620,-300,200])
for i = 1:(D-1)
    plot([500/(D+1)*i,500/(D+1)*(i+1)],[GlobalParams(i),GlobalParams(i+1)],'r:','LineWidth',2);
    hold on
end
plot([0,500/(D+1)*(1)],[0,GlobalParams(1)],'r:','LineWidth',2);
plot([500/(D+1)*D,500],[GlobalParams(D),0],'r:','LineWidth',2);