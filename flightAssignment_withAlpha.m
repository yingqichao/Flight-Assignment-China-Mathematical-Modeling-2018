close all;clc;
%flightData = xlsread('myData.xls');
[~,~,PUCK] = xlsread('datarev.xlsx');
[~,~,TICKET] = xlsread('InputData.xlsx','Tickets');
[~,~,GATE] = xlsread('InputData.xlsx','Gates');
[flightData,~,GATE] = datasetPreprocessing(PUCK,TICKET,GATE);

%Test:100 samples
%flightData = flightData(1:300,:);
GLOBE_SIZE = [];MAX_SIZE = [];GLOBE_ALPHA = [];GLOBE_PORT = [];
for ALPHA=0:5:50
%flightData = load('myData.txt');
    [N,~]=size(flightData);[K,~]=size(GATE);%large_ports = 6;
    skip = 0;max_alpha = 100000;
    Arrangement = zeros(K,200);LastDepart = zeros(K,1);SizeOfPort = ones(K,1);iteration = 1;
    %Initialize
    %flightData,indI,indJ,K,Size
    [Arrangement,LastDepart,SizeOfPort,Stack] = FIFO(Arrangement,LastDepart,SizeOfPort,flightData,1,N,GATE,skip);
    SIZE = length(Stack);
%     max_alpha = SIZE;max_size = SIZE;max_P = length(find(SizeOfPort~=1));
%     GLOBE_SIZE = [SIZE];MAX_SIZE = [SIZE];GLOBE_ALPHA = [SIZE];GLOBE_PORT = [max_P];
    while(iteration<=30)
        valueStack = zeros(4,6);
      for ite = 1:4
        alter_flight = Stack(iteration+ite-1);record_i = 0;msg = 'Nothing was changed.';
        curr_alpha = 1000;
        for i=1:N
            [~,c] = find(Stack==i);
            if(isempty(c))
                [r,COL] = find(Arrangement==i);
                alter_time = flightData{alter_flight,2};
                alter_flight_kind = flightData{alter_flight,5};
                alter_flight_arrive = flightData{alter_flight,4};
                alter_flight_depart = flightData{alter_flight,8};
                %判断是否可以交换:机型一样、DI一致、时间不冲突
                if(COL==1)
                    window = 0;
                else
                    window = flightData{Arrangement(r,COL-1),6};
                end
                canAlt = flightAlter(alter_flight_kind,alter_flight_arrive,alter_flight_depart,GATE{r,6},GATE{r,4},GATE{r,5},alter_time,window);
                if(canAlt)
                    [fakeArrange,LastDepart,SizeOfPort,tmpStack] = arrange_ite(Arrangement,flightData,i,alter_flight,GATE);
                    tmplen = length(tmpStack);tmpP = length(find(SizeOfPort==1));tmpc = tmplen + ALPHA*tmpP;
                    if(tmpc<curr_alpha)
                        curr_alpha = tmpc;curr_max = tmplen;curr_P = tmpP;
                    end
                    if(tmpc<max_alpha)
                        record_i = i;curr_alpha = tmpc;curr_max = tmplen;curr_P = tmpP;
                        %msg = 'New Length:' + num2str(max_size)+'.';
                    end
                end
            end
        end
        valueStack(ite,:) = [ite curr_alpha curr_max curr_P alter_flight record_i];
      end
        [rIte,~] = find(valueStack(:,2)==min(valueStack(:,2)),1,'first');
        bIte = valueStack(rIte,1);newLow = valueStack(rIte,2);newLen = valueStack(rIte,3);newP = valueStack(rIte,4);alt = valueStack(rIte,5);rec = valueStack(rIte,6);
        curr_alpha = newLow;curr_max = newLen;curr_P = newP;
        if(newLow~=1000)
            [Arrangement,LastDepart,SizeOfPort,Stack] = arrange_ite(Arrangement,flightData,rec,alt,GATE);
        end
        SIZE = length(Stack);
        if(rec~=0)
            max_alpha = newLow;
            max_size = newLen;
            max_P = newP;
        end

        fprintf('Iteration:%d,GLOBE_SIZE:%d,GLOBE_ALPHA:%d,GLOBE_P:%d,record:%d\n',iteration,max_size,max_alpha,max_P,record_i);
        if(bIte==1 || rec==0)
            iteration = iteration+1;
        end
    end
        GLOBE_ALPHA = [GLOBE_ALPHA,max_alpha];%MAX_ALPHA = [MAX_ALPHA curr_alpha];
        GLOBE_PORT = [GLOBE_PORT,max_P];%MAX_PORT = [MAX_PORT curr_port];
        GLOBE_SIZE = [GLOBE_SIZE,max_size];%MAX_SIZE = [MAX_SIZE curr_max];
end

% disp(num2str(max_alpha));
% %占用分析
% timePortOccupy = zeros(69,2);
% for i=1:69
%     if(SizeOfPort(i)==1)
%        continue; 
%     end
%     first = max(1,flightData{Arrangement(i,1),2});
%     last = min(2,LastDepart(i));
%     timePortOccupy(i,1) = min(1,(last-first));
%     timePortOccupy(i,2) = SizeOfPort(i)-1;
% end
% xlswrite('timePort.xls',timePortOccupy)
% %宽窄数量
% wideNum = 0;
% for i=1:304
%    if flightData{i,5}=='W'
%       wideNum = wideNum+1; 
%    end
% end
% wideNotArrange = 0;
% for i=1:length(Stack)
%     if flightData{Stack(i),5}=='W'
%       wideNotArrange = wideNotArrange+1; 
%    end
% end
% narrowNum = 304-wideNum;narrowNotArrange = length(Stack)-wideNotArrange;
% narrowRatio = 1-narrowNotArrange/narrowNum;
% wideRatio = 1-wideNotArrange/wideNum;

%打印结果
RATE = 0:10:50;
figure,
plot(RATE,GLOBE_SIZE,'-*'),ylabel('停机坪/登机口数量'),ylim([30,100]),xlabel('alpha加权项');
hold on;
plot(RATE,GLOBE_PORT,'-s');
legend('停机坪数量','使用登机口数量');
hold off;
% print -dmeta pic1;
saveas(gca,'alpha_1.bmp');