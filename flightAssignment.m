close all;clc;
%flightData = xlsread('myData.xls');
[~,~,PUCK] = xlsread('datarev.xlsx');
[~,~,TICKET] = xlsread('InputData.xlsx','Tickets');
[~,~,GATE] = xlsread('InputData.xlsx','Gates');
[flightData,~,GATE] = datasetPreprocessing(PUCK,TICKET,GATE);

%Test:100 samples
%flightData = flightData(1:300,:);


%flightData = load('myData.txt');
[N,~]=size(flightData);[K,~]=size(GATE);%large_ports = 6;
skip = 0;
Arrangement = zeros(K,200);LastDepart = zeros(K,1);SizeOfPort = ones(K,1);iteration = 1;
%Initialize
%flightData,indI,indJ,K,Size
[Arrangement,LastDepart,SizeOfPort,Stack] = FIFO(Arrangement,LastDepart,SizeOfPort,flightData,1,N,GATE,skip);
SIZE = length(Stack);max_size = SIZE;
GLOBE_SIZE = [SIZE];MAX_SIZE = [SIZE];
while(iteration<=40)
    valueStack = zeros(5,4);
%Arrangement,flightData,indI,indJ,N,K,Size
  for ite = 1:5
    alter_flight = Stack(iteration+ite-1);record_i = 0;msg = 'Nothing was changed.';
    curr_max = 100;
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
                if(tmpc<max_size)
                    record_i = i;curr_max = tmpc;
                    %msg = 'New Length:' + num2str(max_size)+'.';
                end
            end
        end
    end
    valueStack(ite,:) = [ite curr_max alter_flight record_i];
  end
    [rIte,~] = find(valueStack(:,2)==min(valueStack(:,2)),1,'first');
    bIte = valueStack(rIte,1);newLow = valueStack(rIte,2);alt = valueStack(rIte,3);rec = valueStack(rIte,4);
    curr_max = newLow;
    if(newLow~=100)
        [Arrangement,LastDepart,SizeOfPort,Stack] = arrange_ite(Arrangement,flightData,rec,alt,GATE);
    end
    SIZE = length(Stack);
    if(rec~=0)
        max_size = newLow;
    end
    
    fprintf('Iteration:%d,GLOBE_SIZE:%d,CURR_SIZE:%d,record:%d\n',iteration,max_size,curr_max,record_i);
    if(bIte==1 || rec==0)
        iteration = iteration+1;
    end
    
    GLOBE_SIZE = [GLOBE_SIZE,max_size];MAX_SIZE = [MAX_SIZE curr_max];
    
end

for i=1:69
    for j=1:200
        if(Arrangement(i,j)~=0)
            flightData{Arrangement(i,j),9} = GATE{i,1};
        else
            break;
        end
    end
end
xlswrite('flightdata.xls',flightData);

disp(num2str(max_size));
xlswrite('arrangement_1.xls',Arrangement);
gante_test(flightData);

%占用分析
timePortOccupy = zeros(69,2);
for i=1:69
    if(SizeOfPort(i)==1)
       continue; 
    end
    first = max(1,flightData{Arrangement(i,1),2});
    last = min(2,LastDepart(i));
    timePortOccupy(i,1) = min(1,(last-first));
    timePortOccupy(i,2) = SizeOfPort(i)-1;
end
xlswrite('timePort.xls',timePortOccupy)
%宽窄数量
wideNum = 0;
for i=1:304
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
narrowNum = 304-wideNum;narrowNotArrange = length(Stack)-wideNotArrange;
narrowRatio = 1-narrowNotArrange/narrowNum;
wideRatio = 1-wideNotArrange/wideNum;

%打印结果
RATE = 1:length(GLOBE_SIZE);
figure,
plot(RATE,GLOBE_SIZE,'-*'),ylabel('至少需要的临时停机坪数量'),ylim([45,70]),xlabel('迭代次数');
hold on;
plot(RATE,MAX_SIZE,'-s');
legend('实际数量','迭代数量');
hold off;
% print -dmeta pic1;
saveas(gca,'quick_1.bmp');