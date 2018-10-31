close all;clc;
%flightData = xlsread('myData.xls');
[~,~,PUCK] = xlsread('datarev.xlsx');
[~,~,TICKET] = xlsread('InputData.xlsx','Tickets');
[~,~,GATE] = xlsread('InputData.xlsx','Gates');
[flightData,~,GATE] = datasetPreprocessing(PUCK,TICKET,GATE);

%Test:100 samples
%flightData = flightData(1:300,:);

GLOBE_SIZE = [];MAX_SIZE = [];
%flightData = load('myData.txt');
[N,~]=size(flightData);[K,~]=size(GATE);%large_ports = 6;
skip = 0;
Arrangement = zeros(K,200);LastDepart = zeros(K,1);SizeOfPort = ones(K,1);iteration = 1;
%Initialize
%flightData,indI,indJ,K,Size
[Arrangement,LastDepart,SizeOfPort,Stack] = FIFO(Arrangement,LastDepart,SizeOfPort,flightData,1,N,GATE,skip);
SIZE = length(Stack);max_size = SIZE;globe_size = SIZE;

ite_number = 30;
tabu = [];

while(iteration<=ite_number)
%Arrangement,flightData,indI,indJ,N,K,Size
    TotalLen = length(Stack);
    for inner_ite = 1:floor(TotalLen/2);
        alter_flight = Stack(inner_ite);record_i = 0;msg = 'Nothing was changed.';values = [];
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
                    tmpc = length(tmpStack);
                    %构成备选组合队列
                    [valueRows,~] = size(values);
                    if(valueRows<6)
                        values = [values;[tmpc alter_flight i]];
                        values = sort(values,1);
                    elseif(tmpc<values(6,1))
                        values(6,:) = [];
                        values = [values;[tmpc alter_flight i]];
                        values = sort(values,1);
                    end
    %                 if(tmpc<max_size)
    %                     max_size = tmpc;record_i = i;
    %                     %msg = 'New Length:' + num2str(max_size)+'.';
    %                 end
                end
            end
        end
    end
    %取最优解
    tabued=0;
    [valueRows,~] = size(values);
    for vi=1:min(6,valueRows)
        bestValue = [values(vi,2),values(vi,3)];bestValue_r = [values(vi,3),values(vi,2)];
        TABUValue = values(vi,1);
        [rT,~] = size(tabu);
        for ti = 1:rT
           if(isequal(bestValue,tabu(ti,:)) || isequal(bestValue_r,tabu(ti,:)))
               if(TABUValue<globe_size)
                  globe_size=TABUValue;
                  tabu(ti,:) = [];
               else
                   tabued = 1;
               end
               break;
           end
        end
        if(tabued==0)
            break;
        end
    end
    %max_size更新
    max_size = TABUValue;
    if(max_size<globe_size)
        globe_size = max_size;
    end
    [Arrangement,LastDepart,SizeOfPort,Stack] = arrange_ite(Arrangement,flightData,bestValue(2),bestValue(1),GATE);
    %Tabu更新
    tabu = [bestValue;tabu];
    [rT,~] = size(tabu);
    if(rT>5)
       tabu(6,:) = []; 
    end
    
%     if(record_i~=0)
%         [Arrangement,LastDepart,SizeOfPort,Stack] = arrange_ite(Arrangement,flightData,record_i,alter_flight,GATE);
%     else
        
    SIZE = length(Stack);
    GLOBE_SIZE = [GLOBE_SIZE globe_size];MAX_SIZE = [MAX_SIZE max_size];
    fprintf('Iteration:%d,Current:%d,globe_size:%d\n',iteration,max_size,globe_size);
%     if(record_i==0)
         iteration = iteration+1;
%     end
end

RATE = 1:30;
figure,
plot(RATE,GLOBE_SIZE,'-*'),ylabel('至少需要的临时停机坪数量'),ylim([45,70]),xlabel('迭代次数');
hold on;
plot(RATE,MAX_SIZE,'-s');
legend('实际数量','迭代数量');
hold off;
print -dmeta pic;
saveas(gca,'result.bmp');
% saveas(gca,[pathname 'pic\' filename(1:end-4) '_paperSSIM.bmp']);
% figure,
% plot(RATE,PC,'*');ylabel('PCQI'),xlabel('Hiding Rate(bit per pixel)');
% hold on;
% plot(bpp,Pcqi,'s');
% legend('Proposed Scheme','Method in [19]');
% hold off;
% print -dmeta paperPCQI;
% saveas(gca,[pathname 'pic\' filename(1:end-4) '_paperPCQI.bmp']);