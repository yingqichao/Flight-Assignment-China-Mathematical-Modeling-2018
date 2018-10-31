%算法介绍：
%功能：返回三个优先级下的准入登机口(最优/次优/全能登机口)
%输入：进场飞机业务 Arrive/Depart， 登机口信息 GATE， 登机口 ports
%输出：三个优先级下的准入登机口(最优/次优/全能登机口)

function [best_ports,qualified_ports,full_ports] = qualify_port(Arrive,Depart,GATE,ports)
    qualified_ports = [];full_ports = [];best_ports = [];
    for i=1:length(ports)
        Allowed_Arrive = GATE{ports(i),4};Allowed_Depart = GATE{ports(i),5};
        %全能机场
        if(strcmp(Allowed_Arrive,'D, I')==1 && strcmp(Allowed_Depart,'D, I')==1 )
            full_ports = [full_ports ports(i)];
        %有一个是两用的机场
        elseif((strcmp(Allowed_Arrive,'D, I')==1 && strcmp(Allowed_Depart,Depart)==1) || (strcmp(Allowed_Depart,'D, I')==1 && strcmp(Allowed_Arrive,Arrive)==1))
            qualified_ports = [qualified_ports ports(i)];
        %唯一匹配的机场
        elseif (strcmp(Allowed_Arrive,Arrive)==1 && strcmp(Allowed_Depart,Depart)==1)
            best_ports = [best_ports ports(i)];
        end
    end
end