function name1 = calcu(path)
global radar1
global radar2
global R

% radar1 = [100 200 300 400 150 250 350 150 250 350 0 466 250 250 466 30];
% radar2 = [0 0 0 0 50 50 50 -50 -50 -50 40 40 -300 300 -40 -20];
% R = [40 40 40 40 40 40 40 40 40 40 20 20 260 277 20 30];
% ����runABC�ж��壨�����ǰ뾶��
nimama = size(radar2,2);  % ������16
fenmu = R./log(20);
node_number = size(path,2); % ά����path�Ǵ������������Ӧ����30
counter = zeros(node_number,1);
countor = zeros(node_number,1);
d_x = 500./(node_number+1);  % �Ǹ���������������ɶ�����͵��ǳ�ʼλ�ðɣ�
% �Һ���������ʲô�ˣ��ο�����621ҳ
% �ο����ĵ�621ҳ����ƽ���ͼ��D��ֱ���и�򻮷ֳ�D+1�飬ÿ��ĳ��ȼ�Ϊd_x
for i = 1:node_number
    for j = 1:nimama % ��һ����в�ĵ�һά���ڶ�����в�ĵ�һά.....
        d = sqrt((radar1(j) - d_x.*i)^2 + (radar2(j) - path(i))^2); % ���룿����
        % ÿһ�飬�൱��ÿһ������Ҫ�������ÿһ���Ĵ��ۺ���
        % һ����node_number������Ҫ��ÿһ������ÿ����в�����������в���ò��ľ���
        % ���������һ��food����������ô����ÿһ�У�Ӧ�þ���������
        counter(i) = counter(i) + exp(-1.*d./fenmu(j));   % �����ܶ�ģ��
    end
end
for i = 1:(node_number-1)  % �������������ۺ����ĵڶ�����
    countor(i) = sqrt((d_x)^2 + (path(i)-path(i+1))^2);
end
bufen1 = sum(countor)./500;
bufen2 = sum(counter);
name1 = bufen1 + bufen2;





