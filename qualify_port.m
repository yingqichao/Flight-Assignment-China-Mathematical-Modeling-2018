%�㷨���ܣ�
%���ܣ������������ȼ��µ�׼��ǻ���(����/����/ȫ�ܵǻ���)
%���룺�����ɻ�ҵ�� Arrive/Depart�� �ǻ�����Ϣ GATE�� �ǻ��� ports
%������������ȼ��µ�׼��ǻ���(����/����/ȫ�ܵǻ���)

function [best_ports,qualified_ports,full_ports] = qualify_port(Arrive,Depart,GATE,ports)
    qualified_ports = [];full_ports = [];best_ports = [];
    for i=1:length(ports)
        Allowed_Arrive = GATE{ports(i),4};Allowed_Depart = GATE{ports(i),5};
        %ȫ�ܻ���
        if(strcmp(Allowed_Arrive,'D, I')==1 && strcmp(Allowed_Depart,'D, I')==1 )
            full_ports = [full_ports ports(i)];
        %��һ�������õĻ���
        elseif((strcmp(Allowed_Arrive,'D, I')==1 && strcmp(Allowed_Depart,Depart)==1) || (strcmp(Allowed_Depart,'D, I')==1 && strcmp(Allowed_Arrive,Arrive)==1))
            qualified_ports = [qualified_ports ports(i)];
        %Ψһƥ��Ļ���
        elseif (strcmp(Allowed_Arrive,Arrive)==1 && strcmp(Allowed_Depart,Depart)==1)
            best_ports = [best_ports ports(i)];
        end
    end
end