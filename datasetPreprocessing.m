%算法介绍：
%功能：格式化数据集
%输入：航班数据 PUCK，所有票务信息 TICKET， 登机口信息 GATE
%输出：航班数据 PUCK，所有票务信息 TICKET， 登机口信息 GATE

%dataset preprocessing
function [PUCK,TICKET,GATE] = datasetPreprocessing(PUCK,TICKET,GATE)
    %PUCK
    PUCK(1,:)=[];
    PUCK(:,11:12)=[];
%     xlswrite('processedData.xlsx',PUCK);%无法对元组做保存
    i=1;[r,~] = size(PUCK);
    while(i<=r)
%         if(strcmp(PUCK{i,1},'PK477'))
%            here=1; 
%         end
        PUCK{i,3}=str2double(PUCK{i,2}(end-1:end))-19+PUCK{i,3};%到达时间：0表示19号的0点，20号就是1.0开始
        PUCK{i,8}=str2double(PUCK{i,7}(end-1:end))-19+PUCK{i,8};%出发时间：同上 ,0.0312是45分钟
        %删除时间为19和21号的航班信息
        if((PUCK{i,3}<1 && PUCK{i,8}<=1) || (PUCK{i,3}>=2 && PUCK{i,8}>2) || (PUCK{i,3}<1 && PUCK{i,8}>2) )
            PUCK(i,:)=[];[r,~] = size(PUCK);
            continue;
        end
        PUCK{i,8} = PUCK{i,8} + 0.0312;
        if(isnumeric(PUCK{i,6}))
            if(PUCK{i,6}==332 || PUCK{i,6}==333 || PUCK{i,6}==773)
                PUCK{i,6} = 'W';
            else
                PUCK{i,6} = 'N';
            end
        else
            if(strcmp(PUCK{i,6},'332')==1 || strcmp(PUCK{i,6},'333')==1 || strcmp(PUCK{i,6},'773')==1 || strcmp(PUCK{i,6},'33E')==1 || strcmp(PUCK{i,6},'33H')==1 || strcmp(PUCK{i,6},'33L')==1)
                PUCK{i,6} = 'W';
            else
                PUCK{i,6} = 'N';
            end
        end
        
        i=i+1;
        
    end
    PUCK(:,2)=[];
    PUCK(:,6)=[];
    %TICKET
    TICKET(1,:)=[]; i=1;
    [r1,~] = size(TICKET);
    while(i<=r1) 
        TICKET{i,4}=str2double(TICKET{i,4}(end-1:end))-19;%到达时间：0表示19号的0点，20号就是1.0开始
        TICKET{i,6}=str2double(TICKET{i,6}(end-1:end))-19;%出发时间：同上
        %删除时间为19和21号的航班信息
        if((TICKET{i,4}<1 && TICKET{i,6}<1) || (TICKET{i,4}>=2 && TICKET{i,6}>=2))
            TICKET(i,:)=[];
        else
            i=i+1;
        end
        [r1,~] = size(TICKET);
    end
    
    %GATE
    GATE(1,:)=[];
    
end