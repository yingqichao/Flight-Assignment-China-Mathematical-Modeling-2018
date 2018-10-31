%算法介绍：
%功能：返回某乘客捷运、行走所需时间
%输入：到达业务 typeA, 出发业务 typeB, 到达厅 locA, 出发厅 locB
%输出：某乘客捷运、行走所需时间

function walk = transferCalc(typeA,typeB,locA,locB)
    comb = [typeA,typeB,locA,locB];walk=0;
    %不需要捷运的情况：typeA==typeB
    %2次捷运：comb = {'I,D,S,S','D,I,S,S'}
    %1次捷运：rest
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
    %厅信息
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