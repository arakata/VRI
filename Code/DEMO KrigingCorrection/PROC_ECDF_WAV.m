clc
%%%%%change in 31 and 155 lines

Krigingtot=loadStructFromFile(strcat(outputfolder,'/',output,'/ppspatialWAVKrigingrain.mat'));

posNE=1:nymd1(1);
posNE(pos)=[];
ppspatialside=str2num(ppspatialside);
PPSpatotNE=zeros(ppspatialside,ppspatialside,nymd1(1));       
PPSpatotNE(:,:,pos)=ppspatial;

KrigingtotNE=zeros(ppspatialside,ppspatialside,nymd1(1));    
KrigingtotNE(:,:,pos)=Krigingtot;

% % Loading station  information  for 34 stations

rain0NE=rainall;
rain0NE(:,posNE)=0;
%rain0NE(out,:)=[];
nodataNE=rain0NE >=0;

%% Generating year xlabel
nymd=size(yearmonthday);

%Create a variable, xdata, that corresponds to the number of months between the start and end dates.
xDatatemp1 = linspace(startDate,endDate,nymd1(1));

%tperiod1=1:8:nymd(2);
yearmonthdayPeriod=yearmonthday1(pos,:);

for i=1:(yf-yi+2)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% number of years , change "2"
   ntemp=sum(yearmonthdayPeriod(:,3) == yi-1+i); 
   yeardayperiod(i)=ntemp; 
end
xDatatemp2 = cumsum(yeardayperiod); % Nunmber of days in the 8 years of analysis
xData=xDatatemp1(xDatatemp2);
%%%%

xDatatemp1 = linspace(startDate,endDate1,nymd1(1)+1);
xDatatemp1tot = xDatatemp1;
xDatatemp2 = xDatatemp1(:,pos);
xDatatemp3=linspace(startDate,endDate1,nymd(2)+1);
xDatatemptot = xDatatemp2;

mkdir(strcat(outputfolder,'/',output,'/ECDFs'));    
mkdir(strcat(outputfolder,'/',output,'/QQplots')); 
mkdir(strcat(outputfolder,'/',output,'/TimeSeries')); 

j=1;

for i=1:Stations_number1 % here we consider stations 1 and 31 that have not been used in the correction procedure
    
    num=char(strtrim(names1(i,:)));
    
    Station_Local=rainall(i,:);
    Kriging=squeeze(Krigingtot(stationsLoc1(i,3),stationsLoc1(i,2),:))';        
    Kriging(Station_Local<0)=[];
    ppspat=squeeze(ppspatial(stationsLoc1(i,3),stationsLoc1(i,2),:))';
    ppspat(Station_Local<0)=[];
    xDatatemp2=xDatatemptot;
    xDatatemp2(Station_Local<0)=[];
    Station_Local(Station_Local<0)=[];
    
    h=figure(85);
    subplot(1,2,1)
    [xt0,tt0,gg0,stats0]=ExeedenceComparisson(Station_Local,ppspat,num,'.','default');
    title([RSdata,' - ',num],'Interpreter','latex','FontSize',14);
    axis([ 0.01 500 0.001 1]);
    stats0=Stadigraph(Station_Local,ppspat,tt0,gg0);
    
    
    subplot(1,2,2)
    [xt1,tt1,gg1,stats1]=ExeedenceComparisson(Station_Local,Kriging,num,'.','default');
    title([RSdata,' - Corrected - ',num],'Interpreter','latex','FontSize',14);
    axis([ 0.01 500 0.001 1]);
    stats1=Stadigraph(Station_Local,Kriging,tt1,gg1);
    
    
    
    saveas(h,strcat(outputfolder,'/',output,'/ECDFs/',['ECDF comparison - ',strtrim(num)]),'jpg');
    saveas(h,strcat(outputfolder,'/',output,'/ECDFs/',['ECDF comparison - ',strtrim(num)]),'fig');
    

    hh=figure(86);    
    
    hwrf=loglog(xt1,gg0,'.','color',[1 140/255 0]);
    hold on
    h0=loglog(xt1,tt1,'.','color','black');
    h1=loglog(xt1,gg1,'.','color','blue');

    title(['Exceedence probability at station ',num],'Interpreter','latex','FontSize',14);
    xlabel('Rainfall amount (mm)','Interpreter','latex','FontSize',14);
    ylabel('Probability','Interpreter','latex','FontSize',14);
    axis([ 0.01 500 0.001 1]);    
    h_legend=legend([hwrf h0 h1],RSdata,'Station','Correction');
    set(h_legend,'Location','SouthWest')
    hold off 
    
    saveas(hh,strcat(outputfolder,'/',output,'/ECDFs/',['ECDF comparison overlap - ',strtrim(num)]),'jpg');
    saveas(hh,strcat(outputfolder,'/',output,'/ECDFs/',['ECDF comparison overlap - ',strtrim(num)]),'fig');

 % % Quantile plots
    
    hhh=figure(88);
    qqplotModif(Station_Local,Kriging,[10 25 50 55 60 65 70 75 80 85 90 95 96 97 98 99 100],num)
    
    saveas(hhh,strcat(outputfolder,'/',output,'/QQplots/',['QQplot_comparison - Station ',num,' up to 100% quantile']),'jpg');
    saveas(hhh,strcat(outputfolder,'/',output,'/QQplots/',['QQplot_comparison - Station ',num,' up to 100% quantile']),'fig');    
    
   
    
%     % % Time series comparisson
% 
% hhhh=figure(89);
% 
% Station_LocalNE=rain0NE(i,:);
% xDatatemp1=xDatatemp1tot;
% ppspatNE=squeeze(PPSpatotNE(stationsLoc1(i,3),stationsLoc1(i,2),:))';        
% ppspatNE(Station_LocalNE<0)=0;
% KrigingNE=squeeze(KrigingtotNE(stationsLoc1(i,3),stationsLoc1(i,2),:))';        
% KrigingNE(Station_LocalNE<0)=0;
% Station_LocalNE(Station_LocalNE<0)=0;
% 
% 
% h1=plot(xDatatemp1,[Station_LocalNE 0],'--g');
% hold on
% plot(xDatatemp1,[Station_LocalNE 0],'.g')
% axis tight
% %Set the number of XTicks to the number of points in xData.
% set(gca,'XTick',xData)
% 
% %Label the x-axis with month names, preserving the total number of ticks by using the 'keepticks' option.
% datetick('x','yyyy','keeplimits')
% 
% h2=plot(xDatatemp1,[ppspatNE 0],'--','color',[0.2 0.2 0.2]);
% plot(xDatatemp1,[ppspatNE 0],'.','color',[0.2 0.2 0.2])
% 
% h3=plot(xDatatemp1,[KrigingNE 0],'--r');
% plot(xDatatemp1,[KrigingNE 0],'.r')
% 
% 
% xlabel('$days$','FontSize',14,'Interpreter','latex')
% ylabel('$rainfall(mm)$','FontSize',14,'Interpreter','latex')
% 
% legend([h1 h2 h3],'Observed',RSdata,'Reconstructed')
%         
% hold off
%     
% datelim=xlim;
% binSize=(datelim(2)-datelim(1))/14;
% 
% binsize=(xData(2)-xData(1))/2;
% for year=yi:yf
% 
% months=[year,11,1;year,12,1;year+1,1,1;year+1,2,1;year+1,3,1;year+1,4,1];  %%%%%%%%%%%%%%%%%%%%%%%%%% change!!
% monthnum=datenum(months)';
% 
% %Select a starting date.
% startDate = monthnum(1);
% %Select an ending date.
% endDate = monthnum(end);
% 
% xlim([startDate endDate])
% set(gca,'XTick',monthnum)
% 
% %Label the x-axis with month names, preserving the total number of ticks by using the 'keepticks' option.
% datetick('x','mmm','keeplimits')
% 
% title(['$',num,'$  $',num2str(year),'$-$',num2str(year+1),'$'],'FontSize',14,'Interpreter','latex')
%     saveas(hhhh,strcat(outputfolder,'/',output,'/TimeSeries/',['TimeSeriesComparison - Station ',num,' - ',num2str(year)]),'jpg');
%     saveas(hhhh,strcat(outputfolder,'/',output,'/TimeSeries/',['TimeSeriesComparison - Station ',num,' - ',num2str(year)]),'fig');    
%     %export_fig(strcat(datafolder,'/',output,'/TimeSeries/',['TimeSeriesComparison - Station ',num,' - ',num2str(year)]),'-nocrop','-transparent','-eps')
% 
% end

% %  save tables of stats for santa Rosa and Ananea with respect to the
% statistics of the stations and directly from WRF

    tables0(j:j+1,:)=stats0';
    tables1(j:j+1,:)=stats1';
   
    j=j+2;


end


save(strcat(outputfolder,'/',output,'/Statistics_table.mat'),'tables0')
dlmwrite(strcat(outputfolder,'/',output,'/Statistics_table.txt'),tables0,'delimiter',' ','precision','%10.2f');
save(strcat(outputfolder,'/',output,'/Statistics_table_corrected.mat'),'tables1')
dlmwrite(strcat(outputfolder,'/',output,'/Statistics_table_corrected.txt'),tables1,'delimiter',' ','precision','%10.2f');

