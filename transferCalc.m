%�㷨���ܣ�
%���ܣ�����ĳ�˿ͽ��ˡ���������ʱ��
%���룺����ҵ�� typeA, ����ҵ�� typeB, ������ locA, ������ locB
%�����ĳ�˿ͽ��ˡ���������ʱ��

function walk = transferCalc(typeA,typeB,locA,locB)
    comb = [typeA,typeB,locA,locB];walk=0;
    %����Ҫ���˵������typeA==typeB
    %2�ν��ˣ�comb = {'I,D,S,S','D,I,S,S'}
    %1�ν��ˣ�rest
    switch comb
        case {'DDSS','IISS','DDTT','IITT'}
            jieyunTimes = 0;
        case {'DISS','IDSS'}
            jieyunTimes = 2;
        otherwise
            jieyunTimes = 1;
    end
    jieyun = jieyunTimes*8;
    walk = walk+jieyun;
    %����Ϣ
    if(locA(1)==locB(1))
            walk = walk+10;
    else
        walk = walk+20;
    end
    loc = [locA(2),locB(2)];
    switch loc
        case {'NS','SN','WE','EW'}
            walk = walk+10;
        case {'NN','SS','WW','EE'}
        otherwise
            walk = walk+5;
    end
end