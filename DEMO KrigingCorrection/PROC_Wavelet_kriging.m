close all
clc 
ppspatialside1=str2num(ppspatialside);
ppspatial0=ppspatial;
%rain0=Stations;


%%%%%
% Using kriging weights

% Variogram is only considered upto a distance of ~100 km because there is
% no point in considering points farther than that since the lambdas for the
% stations located farther than that ~100 becomes closer and closer to zero 


lambda =loadStructFromFile(strcat(outputfolder,'/',output,'/','LambdasfromSpat',ppspatialside,'x',ppspatialside,'.mat')); % Recall stations were removed in 
                                                                              % PROC_kriging_lambda since these were not 
lambda = lambda(:,:,1:nsize(3));

nlambda=size(lambda);

% % Saving figures for lambda weights for many days

mkdir(strcat(outputfolder,'/',output,'/LambdasImagesForStations'));

for day=1:50:ntemp
    
    cday=num2str(yearmonthday(day,2));
    cmonth=num2str(yearmonthday(day,1));
    cyear=num2str(yearmonthday(day,3));
    
%     
% for i=1:Stations_number
% 
% nam=strtrim(names(i,:));    
%     
% h=figure(83);
% 
% %%%%%%%% num 16*16
% Imlambda=reshape(lambda(i,:,day),[ppspatialside1,ppspatialside1]);  
% 
% imagesc(Imlambda);
% colorbar
% title(['Area weight with respect to station ',strtrim(nam),' - ',cmonth,'/',cday,'/',cyear],'Interpreter','latex','FontSize',14);
% saveas(h,strcat(outputfolder,'/',output,'/LambdasImagesForStations/',['Area weight with respect to station ',strtrim(nam),'_',cmonth,'_',cday,'_',cyear]),'jpg');
% saveas(h,strcat(outputfolder,'/',output,'/LambdasImagesForStations/',['Area weight with respect to station ',strtrim(nam),'_',cmonth,'_',cday,'_',cyear]),'fig');
% end

end

xhatkriging=zeros(nsize(1),nsize(2),nsize(3));

for nn=1:nlambda(2)
nn
        [n1,n2] = ind2sub([nsize(1),nsize(2)],nn);

        
%         iiii=10
%         n1=stationsLoc(iiii,3);
%         
%         n2=stationsLoc(iiii,2);
%         
%         nn=sub2ind([nsize(1),nsize(2)],n1,n2)
        
        % Rainfall time series corresponding to the kriging weight classification
        lamb=squeeze(lambda(1:end,nn,:));
        rain=sum(lamb.*rain0,1)';
        
        % The usual NDVI (lag corrected)
        ppspatialm=squeeze(ppspatial0(n1,n2,:));

         %figure(10)
         %[nw,hh_diff,stat]=nhhlevel(rain,ppspatialm,maxLevel,mwave);   
        
%         rainstandard=(rain-mean(rain))./std(rain);
%         
%         wrfstandard=(ppspatialm-mean(ppspatialm))./std(ppspatialm);
        
%         figure(10)
%         [nw,hh_diff,stat]=nhhlevel(rainstandard,wrfstandard,maxLevel,mwave);   
%         
        
        nw=2; % Pragmatic choice ! Show that 3 or 4 is the case using goodness of fit indicators
%        [nw,hh_diff]=nhhlevel(rain,wrf,maxLevel,mwave);   

%% Aplicacion espacial del modelo de reconstruccion de precipitacion 


        %Aplicacion del codigo de reconstruccion
        [rec]=rec1Dwavelet(rain,ppspatialm,nw,mwave,fsc);

        %[xt1,tt1,gg1,stats1]=ExeedenceComparisson(Station_Local,Kriging,num,'.','default');
        
        step=-0.5;
        k=1;
        for i=0:step:-30

        temp=rec+i;
        temp(temp< 0) = 0;
        
        rmse(k)=sqrt(mean((temp-rain).^2));
        k=k+1;      
        end
        
        rec1=rec+find(rmse == min(rmse),1,'first')*step;
        rec1(rec1 <0)=0;
        
        %Constructing de la matriz espacial de salida
        xhatkriging(n1,n2,:)=rec1;

end

% figure(3)
% day=110;
% A1=max(max(WRF(:,:,day)));
% A2=max(max(xhatWRFkriging(:,:,day)));
% A4=min([A1 A2]);
% subplot(1,2,1);imagesc(WRF(:,:,day)); colorbar
% subplot(1,2,2);imagesc(xhatWRFkriging(:,:,day)); colorbar


save(strcat(outputfolder,'/',output,'/ppspatialWAVKrigingrain.mat'),'xhatkriging')

% Plotting some images: Original WRF vs Wavelet/Kriging corrected WRF

dir='MethodComparison';
mkdir(strcat(outputfolder,'/',output,'/',dir));

%load('yearmonthday')

for i=1:1:ntemp
daynn=i;
dayn=num2str(yearmonthday(daynn,2));
monthn=num2str(yearmonthday(daynn,1));
yearn=num2str(yearmonthday(daynn,3));


%scale=max([max(max(xhatkriging(:,:,daynn))),max(max(xhatkriging(:,:,daynn)))]);
h=figure(3);
subplot(1,2,1); imagesc(ppspatial(:,:,daynn)); colorbar;
title([RSdata,' - ',dayn,'/',monthn,'/',yearn],'Interpreter','latex','FontSize',14)
subplot(1,2,2); imagesc(xhatkriging(:,:,daynn)); colorbar;%,[0,scale]); colorbar;
title([RSdata,' - ','Corrected - ',dayn,'/',monthn,'/',yearn],'Interpreter','latex','FontSize',14)

saveas(h,strcat(outputfolder,'/',output,'/',dir,'/',['Comparisonscaling - ',dayn,'_',monthn,'_',yearn]),'jpg');
saveas(h,strcat(outputfolder,'/',output,'/',dir,'/',['Comparisonscaling - ',dayn,'_',monthn,'_',yearn]),'fig');

end

