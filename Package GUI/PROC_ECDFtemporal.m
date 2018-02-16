clear

%  ECDF plots

%  loading time series information

%  year/month/day information

load('StationSimulated')

load('yearmonthday')

load('StationsInfo')

Stations_names=load('Stations_names19');
Stations_names=Stations_names.names;  % names of stations 1 to 24 (in that order). For example, station 1 is Stations_names(1,:)


i=15;

num=Stations_names(i,:);

disp(' ')
disp('Exceedance plot of observed versus generated rainfall')
disp(' ')
pause(0.5)


subplot(1,2,1)
[xt,tt,gg,stats]=ExeedenceComparisson(StationsLocal(i,:),StationCorrectedSeries(i,:),num,'.','confidence');

grid on

disp(' ')
disp('QQplot of observed versus generated rainfall')
disp(' ')
pause(0.5)


subplot(1,2,2)
qqplotModif(StationsLocal(i,:),StationCorrectedSeries(i,:),[10 25 50 55 60 65 70 75 80 85 90 95 96 97 98 99],num)

grid on
    
disp(' ')
disp('Press any key to see the statistics and goodness of fit')
disp('between observed and generated rainfall')
disp(' ')
pause(0.5)


printmat(stats,'Statistics','HURST MEAN MIN MAX SKEW Q25 Q50 Q75 VAR MAE RMSE CORR BIAS% NSE RSR','Local  Generated')
      % hurst coefficient,mean, min, max, skewness, quantile 25, quantile 50, 
      % quantile 75, variance, mean absolute error, root mean square error, 
      % correlation, percentage bias, Nash-Sutclieffe efficiency coefficient.  
      
      
      