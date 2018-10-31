%�㷨���ܣ�
%���ܣ���λ��ͣ��ƺ�ĺ���indJ�滻λ�ڹ̶���λ�ĺ���indI�������ݡ��Ƚ��ȳ���ԭ�����indI����������к���İ��ŷ���
%���룺�Ż�ǰ��λ������� Arrangement�����к�����Ϣ flightData�� indI�� indJ�� �ǻ�����Ϣ GATE
%��������»�λ������� Arrangement��ÿ���ǻ��ں�ʱ���� LastDepart�� ÿ���ǻ����Ѱ��ź������� SizeOfPort�� λ��ͣ��ƺ�ĺ������ Stack 

%Input-->flightData:flight info,indI:removed flight,indJ:added flight.
%K:num of ports,Size:num of large ports
%Output-->Arrangement:newest result,Stack:not planned flights

function [Arrangement,LastDepart,SizeOfPort,Stack] = arrange_ite(Arrangement,flightData,indI,indJ,GATE)
    [K,~] = size(GATE);[N,~] = size(flightData);
    %Remove indI to END flights
    for i=indI:N
       [r,c] = find(Arrangement==i);
       if(length(r)>1)
           debug =1;
       end
       Arrangement(r,c) = 0;
    end
    SizeOfPort = zeros(K,1);LastDepart = zeros(K,1);
    for j=1:K
        temp = find(Arrangement(j,:)>0,1,'last');
        c = length(temp);
        if(c==0)
            SizeOfPort(j) = 1;LastDepart(j) = 0;
        else
            SizeOfPort(j) = temp+1;LastDepart(j) = flightData{Arrangement(j,SizeOfPort(j)-1),6};
        end
        
    end
    %Add indJ
    [Arrangement,LastDepart,SizeOfPort,~] = FIFO(Arrangement,LastDepart,SizeOfPort,flightData,indJ,indJ,GATE,0);
    %Regular FIFO from indI+1 to END(skip indJ)
    skip = indJ;
    [Arrangement,LastDepart,SizeOfPort,Stack2] = FIFO(Arrangement,LastDepart,SizeOfPort,flightData,indI+1,N,GATE,skip);
    %final check
    Stack1 = [];
    for k=1:indI
        [r,~] = find(Arrangement==k);
        if(isempty(r))
            Stack1 = [Stack1 k];
        end
    end
    Stack = [Stack1 Stack2];
end