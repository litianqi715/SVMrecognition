%**************************************************************************
%�������ƣ�DAG_train()
%������load pattern��ѵ����������
%����ֵ��svmStruct saved to file svmStruct.mat: ѵ����ϵ�֧������������
%����ֵ��array: val pos
%�������ܣ�����ѵ���������������޻�ͼ֧��������
%**************************************************************************
function pos=DAG_train()
load templet pattern
d=zeros(10,10);
sm=zeros(10,10);
for i=1:10
    class(i).mu=mean(pattern(i).feature,2);             %����ѵ�������ľ�ֵ����
    sum=0;
    for j=1:pattern(i).num
        a=(pattern(i).feature(:,j)-class(i).mu).^2;
        b=0;
        for k=1:25
            b=b+a(k);
        end
        sum=sum+sqrt(b);
    end
    class(i).sigma=1/(pattern(i).num-1)*sum;            %����ı�׼��
end
for i=1:10
    for j=1:10
        a=(class(i).mu-class(j).mu).^2;
        b=0;
        for k=1:25
            b=b+a(k);
        end
        d(i,j)=sqrt(b);                                 %��i��͵�j��֮��ľ���
        sm(i,j)=d(i,j)/(class(i).sigma+class(j).sigma); %��i��͵�j��֮��ķ����Բ��
    end
end

%���ȣ��ֱ��ÿһ��������9��ķ����Բ�Ȱ���С�����˳��������У������±��****
for i=1:10
    A=[sm(i,:);[1,2,3,4,5,6,7,8,9,10]];
    A=A';
    B=sortrows(A,1);
    up_smval(:,i)=B(:,1);
    up_smpos(:,i)=B(:,2);
end

%Ȼ����� up_smval(2,:)��ֵ�����Ӵ�С��˳�򣬶���Ӧ������������**********
a=[];
for i=1:10
    sum=0;
    for j=2:10
         sum=sum+up_smval(j,i)*10^(10-j);
    end
    a(i)=sum;    % ������������Եĺ�
end
a=[a;[1,2,3,4,5,6,7,8,9,10]];
a=a';
b=sortrows(a,-1);
val=b(:,1);
pos=b(:,2);
    
%���õ�������������pos���������ŵ�������β�������ķֲ����ʾ��������죬
%���������޻�ͼ�����˽ṹ****************************************************
patternNum=50;
for i=1:9
    for k=10:-1:(i+1)
        A=pattern(pos(i)).feature(:,1:patternNum);
        A=A';
        B=pattern(pos(k)).feature(:,1:patternNum);
        B=B';
        x(i,k).feature=[A;B];
    end    
end
for i=1:9
    for k=10:-1:(i+1)
        z=ones(1,patternNum*2);
        z(1:patternNum)=-1;
        z=z';
        %��������֧��������ѵ����������浽svmStruct�ṹ��
        svmStruct(i,k)=svmtrain(x(i,k).feature,z);
    end
end
save svmStruct svmStruct;