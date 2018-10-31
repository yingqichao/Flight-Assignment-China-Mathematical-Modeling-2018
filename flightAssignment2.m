close all;clc;
%flightData = xlsread('myData.xls');
[~,~,PUCK] = xlsread('datarev.xlsx');
[~,~,TICKET] = xlsread('InputData.xlsx','Tickets');
[~,~,GATE] = xlsread('InputData.xlsx','Gates');
[flightData,TICKET,GATE] = datasetPreprocessing(PUCK,TICKET,GATE);

[r,~] = size(flightData);
% Test:100 samples
% flightData = flightData(1:100,:);

arriveMap = containers.Map() ;departMap = containers.Map();
for i=1:r
    key = [flightData{i,3},'_',num2str(floor(flightData{i,2}))];
    arriveMap(key)=i ;
    key = [flightData{i,7},'_',num2str(floor(flightData{i,6}))];
    departMap(key)=i ;
end

%flightData = load('myData.txt');
[N,~]=size(flightData);[K,~]=size(GATE);%large_ports = 6;
skip = 0;
Arrangement = zeros(K,200);LastDepart = zeros(K,1);SizeOfPort = ones(K,1);iteration = 1;
%Initialize
%flightData,indI,indJ,K,Size
[Arrangement,LastDepart,SizeOfPort,Stack] = FIFO(Arrangement,LastDepart,SizeOfPort,flightData,1,N,GATE,skip);
SIZE = length(Stack);max_size = SIZE;
GLOBE_SIZE = [SIZE];MAX_SIZE = [SIZE];MIN_MOVE = [];minMovement=500000000;EQUAL=[];FAIL = [];

while(iteration<=SIZE)
%Arrangement,flightData,indI,indJ,N,K,Size
    alter_flight = Stack(iteration);record_i = 0;curr_max = 100;eq=0;mv=0;mM=minMovement;
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
                if(tmpc<curr_max)
                    curr_max = tmpc;
                end
                %Movement judge
                if(tmpc==max_size)
                   [move,~] = calcMovement(arriveMap,departMap,TICKET,Arrangement,Stack,flightData);
                   eq=eq+1;
                   if(mM>move)
                       record_i = i;mM=move;
                   end
                end
                if(tmpc<max_size)
                    mv=1;
                    max_size = tmpc;record_i = i;mM=move;curr_max = tmpc;
                    %msg = 'New Length:' + num2str(max_size)+'.';
                end
            end
        end
    end
    if(record_i~=0)
        [Arrangement,LastDepart,SizeOfPort,Stack] = arrange_ite(Arrangement,flightData,record_i,alter_flight,GATE);
    end
    SIZE = length(Stack);
    [mM,failure] = calcMovement(arriveMap,departMap,TICKET,Arrangement,Stack,flightData);
    if(mM>=minMovement)
        mov=1;
    end
    minMovement=mM;
    
    fprintf('Iteration:%d,Current MIN:%d,record:%d,minMovement:%d,fails:%d\n',iteration,max_size,record_i,minMovement,failure);
    GLOBE_SIZE = [GLOBE_SIZE,max_size];MAX_SIZE = [MAX_SIZE curr_max];MIN_MOVE = [MIN_MOVE minMovement];
    EQUAL=[EQUAL eq];FAIL = [FAIL failure];
    if(mv==0)
        iteration = iteration+1;
    end
end
xlswrite('arrangement_2.xls',Arrangement);

for i=1:69
    for j=1:200
        if(Arrangement(i,j)~=0)
            flightData{Arrangement(i,j),11} = GATE{i,1};
        else
            break;
        end
    end
end

xlswrite('flightdata.xls',flightData);
disp(max_size);

%宽窄数量
wideNum = 0;
for i=1:303
   if flightData{i,5}=='W'
      wideNum = wideNum+1; 
   end
end
wideNotArrange = 0;
for i=1:length(Stack)
    if flightData{Stack(i),5}=='W'
      wideNotArrange = wideNotArrange+1; 
   end
end
narrowNum = 303-wideNum;narrowNotArrange = length(Stack)-wideNotArrange;
narrowRatio = 1-narrowNotArrange/narrowNum;
wideRatio = 1-wideNotArrange/wideNum;


RATE = 1:length(GLOBE_SIZE);
figure,
plot(RATE,GLOBE_SIZE,'-*'),ylabel('至少需要的临时停机坪数量'),ylim([45,70]),xlabel('迭代次数');
hold on;
plot(RATE,MAX_SIZE,'-s');
legend('实际数量','迭代数量');
hold off;
% print -dmeta pic1;
saveas(gca,'solve_2.bmp');

RATE = 1:length(MIN_MOVE);
figure,
plot(RATE,MIN_MOVE,'-*'),ylabel('最短总流程时间'),xlabel('迭代次数');
saveas(gca,'move.bmp');
figure,
plot(RATE,EQUAL,'-*'),ylabel('同解数量'),xlabel('迭代次数');
saveas(gca,'ite.bmp');
RATE = 1:length(FAIL);
figure,
plot(RATE,FAIL,'-*'),ylabel('换乘失败旅客数'),ylim([18 25]),xlabel('迭代次数');
saveas(gca,'fail.bmp');
