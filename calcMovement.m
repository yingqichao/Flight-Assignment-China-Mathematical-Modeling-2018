%算法介绍：
%功能：根据最新的航班安排，计算所有旅客换乘所需时间
%输入：到达航班映射数据结构 arriveMap，出发航班映射数据结构 departMap，所有票务信息 TICKET， 机位安排情况 Arrangement， 登机口信息 GATE
%位于停机坪的航班队列 Stack ，所有航班信息 flightData
%输出：所有旅客转机时间总和 move， 换乘失败旅客人数 failure

function [move,failure] = calcMovement(arriveMap,departMap,TICKET,Arrangement,Stack,flightData)
    [r,~] = size(TICKET);invalid = 0;move = 0;T_num = 28;failure = 0;
    for i=1:r
        arrFlight = [TICKET{i,3},'_',num2str(TICKET{i,4})];depFlight = [TICKET{i,5},'_',num2str(TICKET{i,6})];
        isValidA = isKey(arriveMap,arrFlight);
        isValidB = isKey(departMap,depFlight);
        %排除无效航班记录：包含19号就飞来的一部分飞机以及错误信息
        if(isValidA+isValidB==2)
            flightA = arriveMap(arrFlight);flightB = departMap(depFlight);
            %排除在停机坪的情况
            indA = find(Stack==flightA);indB = find(Stack==flightB);
            [arrA,~] = find(Arrangement==flightA);[arrB,~] = find(Arrangement==flightB);
            if(isempty(indA) && isempty(indB))
                persons = TICKET{i,2};
                %D:0,I:1,T:0,S:1
                s1 = flightData{flightA,4}=='I';s2 = flightData{flightB,8}=='I';
                s3 = arrA>T_num;s4 = arrB>T_num;
                transfer = s1*1000+s2*100+s3*10+s4;
                switch transfer
                    case {0,11}
                        temp = 15;
                    case {10,1,1100,1111}
                        temp = 20;
                    case {1101,1110}
                        temp = 30;
                    case {1000,100,111}
                        temp = 35;
                    case {1010,110,101}
                        temp = 40;
                     case {1011}
                        temp = 45;
                end
                land = flightData{flightA,2};depart = flightData{flightB,6};
                %检查是否错过航班
                if(land+temp/1440>depart-0.0312)
                    temp = 360;
                    failure = failure+persons;
                end
                move = move+(persons*temp);
            end
        else
            invalid = invalid+1;
        end
    end
    disp(num2str(invalid));

end