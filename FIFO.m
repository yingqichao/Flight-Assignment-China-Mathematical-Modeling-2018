%算法介绍：
%功能：根据“先进先出”原则将indI到indJ之间的航班安排到登机口上
%输入：优化前机位安排情况 Arrangement，所有航班信息 flightData， indI， indJ， 登机口信息 GATE， 每个登机口何时可用 LastDepart， 每个登机口已安排航班数量 SizeOfPort
%输出：最新机位安排情况 Arrangement，每个登机口何时可用 LastDepart， 每个登机口已安排航班数量 SizeOfPort， 位于停机坪的航班队列 Stack 

function [Arrangement,LastDepart,SizeOfPort,Stack] = FIFO(Arrangement,LastDepart,SizeOfPort,flightData,indI,indJ,GATE,skip)
    n_ports = [];w_ports = [];
    [r,~] = size(GATE);
    for i=1:r
        if(GATE{i,6}=='W')
            w_ports = [w_ports i];
        else
            n_ports = [n_ports i];
        end
    end
    
    Stack = []; 
    for i=indI:indJ
        if(skip==i)
                continue;
        end
        debug_kind = flightData{i,5};debug_arriveType = flightData{i,4};debug_departType = flightData{i,8};
        debug_arrive = flightData{i,2};debug_depart = flightData{i,6};
        if(debug_kind=='W')
            [best_ports,qualified_ports,full_ports] = qualify_port(debug_arriveType,debug_departType,GATE,w_ports);
        else
            [best_ports,qualified_ports,full_ports] = qualify_port(debug_arriveType,debug_departType,GATE,n_ports);
        end
        if(isempty(qualified_ports) && isempty(best_ports) && isempty(full_ports))
            Stack = [Stack i];
        else
            %找最佳解
            MIN = min(LastDepart(best_ports));
            if(MIN<=debug_arrive)
                portInd = find(LastDepart(best_ports)==MIN,1,'first');
                port = best_ports(portInd);
            else
                %找次佳解
                MIN = min(LastDepart(qualified_ports));
                if(MIN<=debug_arrive)
                    portInd = find(LastDepart(qualified_ports)==MIN,1,'first');
                    port = qualified_ports(portInd);
                else
                    %找最差解
                    MIN = min(LastDepart(full_ports));
                    if(MIN<=debug_arrive)
                        portInd = find(LastDepart(full_ports)==MIN,1,'first');
                        port = full_ports(portInd);
                    end
                end
            end
            %此时如果MIN>flightData{i,2}，就刷新Arrangement,SizeOfPort和LastDepart，otherwise加入Stack
            if(MIN>debug_arrive)
                Stack = [Stack i];
            else
                Arrangement(port,SizeOfPort(port)) = i;
                SizeOfPort(port) = SizeOfPort(port)+1;
                LastDepart(port) = debug_depart;
            end
        end
    end
    
end