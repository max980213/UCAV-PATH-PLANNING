function fFitness=calculateFitness(fObjV)
fFitness=zeros(size(fObjV));
ind=find(fObjV>=0);
fFitness(ind)=1./(fObjV(ind)*0.5+1);   % ��Ϊ0.5Ч������õģ����ڲ�������˵
% fFitness(ind) = exp(-fObjV(ind)*0.05);
ind=find(fObjV<0);  % ��ô����С��0���أ�!
fFitness(ind)=1+abs(fObjV(ind));
