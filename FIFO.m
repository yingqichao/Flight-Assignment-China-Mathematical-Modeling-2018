%�㷨���ܣ�
%���ܣ����ݡ��Ƚ��ȳ���ԭ��indI��indJ֮��ĺ��ల�ŵ��ǻ�����
%���룺�Ż�ǰ��λ������� Arrangement�����к�����Ϣ flightData�� indI�� indJ�� �ǻ�����Ϣ GATE�� ÿ���ǻ��ں�ʱ���� LastDepart�� ÿ���ǻ����Ѱ��ź������� SizeOfPort
%��������»�λ������� Arrangement��ÿ���ǻ��ں�ʱ���� LastDepart�� ÿ���ǻ����Ѱ��ź������� SizeOfPort�� λ��ͣ��ƺ�ĺ������ Stack 

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
            %����ѽ�
            MIN = min(LastDepart(best_ports));
            if(MIN<=debug_arrive)
                portInd = find(LastDepart(best_ports)==MIN,1,'first');
                port = best_ports(portInd);
            else
                %�Ҵμѽ�
                MIN = min(LastDepart(qualified_ports));
                if(MIN<=debug_arrive)
                    portInd = find(LastDepart(qualified_ports)==MIN,1,'first');
                    port = qualified_ports(portInd);
                else
                    %������
                    MIN = min(LastDepart(full_ports));
                    if(MIN<=debug_arrive)
                        portInd = find(LastDepart(full_ports)==MIN,1,'first');
                        port = full_ports(portInd);
                    end
                end
            end
            %��ʱ���MIN>flightData{i,2}����ˢ��Arrangement,SizeOfPort��LastDepart��otherwise����Stack
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