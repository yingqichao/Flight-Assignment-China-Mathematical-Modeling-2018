%�㷨���ܣ�
%���ܣ��ж�λ��ͣ��ƺ�ĺ���indJ�Ƿ�����滻λ�ڵǻ��ڵĺ���indI
%���룺����/��������ʱ�䡢ҵ�񡢻�����Ϣ
%������Ƿ�����滻 canAlt

function canAlt = flightAlter(alter_kind,alter_arrive,alter_depart,GATE_kind,GATE_arrive,GATE_depart,alter_time,LastDepart)
    if(alter_kind==GATE_kind)
        if((strcmp(GATE_arrive,'D, I')==1 || strcmp(GATE_arrive,alter_arrive)==1) && (strcmp(GATE_depart,'D, I')==1 || strcmp(GATE_depart,alter_depart)==1))
            if(alter_time>LastDepart)
                canAlt = 1;
            else
                canAlt = 0;
            end
        else
            canAlt = 0;
        end
    else
        canAlt = 0;
    end
end