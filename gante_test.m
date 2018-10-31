close all;
    [~,~,flightData] = xlsread('flightdata.xls');
    [Arrangement,~,~] = xlsread('arrangement_2.xls');
    [rF,~] = size(flightData);
    
    figure,
    axis([-24,36,30,69]);%x轴 y轴的范围

    set(gca,'xtick',-24:1:24) ;%x轴的增长幅度

    set(gca,'ytick',0:1:69) ;%y轴的增长幅度

    xlabel('时间戳','FontName','微软雅黑','Color','black','FontSize',10)

    ylabel('登机口','FontName','微软雅黑','Color','black','FontSize',8,'Rotation',90)

%     title('航班分配时刻表（甘特图）','fontname','微软雅黑','Color','b','FontSize',10);%图形的标题


for i=31:69
    for j=1:200
        flight = Arrangement(i,j);
      if(flight~=0)
          rec(1) = flightData{flight,2}*24-24;%矩形的横坐标

          rec(2) = i-1;  %矩形的纵坐标

          rec(3) = flightData{flight,6}*24-24;  %矩形的x轴方向的长度

          rec(4) = 0.6; 

          rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',[0,0,1]);%draw every rectangle  

          text(flightData{flight,2}*24-24+0.5,i-1+0.3,flightData{flight,1},'FontWeight','Bold','FontSize',8,'Color','white');%label the id of every task  ，字体的坐标和其它特性
      else
         break; 
      end
    end
end

saveas(gca,'gante_2_2.bmp');
    
