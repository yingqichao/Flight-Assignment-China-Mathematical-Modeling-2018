close all;
    [~,~,flightData] = xlsread('flightdata.xls');
    [Arrangement,~,~] = xlsread('arrangement_2.xls');
    [rF,~] = size(flightData);
    
    figure,
    axis([-24,36,30,69]);%x�� y��ķ�Χ

    set(gca,'xtick',-24:1:24) ;%x�����������

    set(gca,'ytick',0:1:69) ;%y�����������

    xlabel('ʱ���','FontName','΢���ź�','Color','black','FontSize',10)

    ylabel('�ǻ���','FontName','΢���ź�','Color','black','FontSize',8,'Rotation',90)

%     title('�������ʱ�̱�����ͼ��','fontname','΢���ź�','Color','b','FontSize',10);%ͼ�εı���


for i=31:69
    for j=1:200
        flight = Arrangement(i,j);
      if(flight~=0)
          rec(1) = flightData{flight,2}*24-24;%���εĺ�����

          rec(2) = i-1;  %���ε�������

          rec(3) = flightData{flight,6}*24-24;  %���ε�x�᷽��ĳ���

          rec(4) = 0.6; 

          rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',[0,0,1]);%draw every rectangle  

          text(flightData{flight,2}*24-24+0.5,i-1+0.3,flightData{flight,1},'FontWeight','Bold','FontSize',8,'Color','white');%label the id of every task  ��������������������
      else
         break; 
      end
    end
end

saveas(gca,'gante_2_2.bmp');
    
