%算法介绍：
%功能：判断位于停机坪的航班indJ是否可以替换位于登机口的航班indI
%输入：输入/输出航班的时间、业务、机型信息
%输出：是否可以替换 canAlt

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