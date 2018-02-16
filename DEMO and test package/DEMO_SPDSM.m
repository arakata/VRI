clear
clc
clf
close all

cd('Package')

disp('SPDSM Demonstration')
disp(' ')
disp('The region under study is:')
disp(' ')
disp('Press any key to continue')
pause

load('studyarea.mat')
load('stationsLocOBS19.mat')
load('stationsLocGEN19.mat')
load('Stations_names19.mat')

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])

imagesc(studyarea)
title('Study Area Stations','interpreter','latex','Fontsize',14)

disp(' ')
disp('The stations location are:')
disp(' ')
disp('Press any key to continue')
disp(' ')
pause



StationPositions=[220 280; 110 220; 200 225; 160 400;...
    280 410 ; 70 200; 400 250; 250 90; 305 305; 375 340;...
    90 440; 160 325; 30 240; 175 445; 260 195; 80 365;...
    170 170; 240 445 ;460 55];

    for i=1:19

    text(StationPositions(i,1),StationPositions(i,2),'$\bullet$','color','r','Fontsize',18,'interpreter','latex','Fontsize',14,'FontWeight','bold')
    text(StationPositions(i,1),StationPositions(i,2)-25,strtrim(names(i,:)),'color','k'...
        ,'BackgroundColor',[1 1 1],'HorizontalAlignment','center','interpreter','latex','Fontsize',14,'FontWeight','bold')
    pause(0.5)
    
    end

disp('Press any key to continue')    
pause

% Lognormal analysis

disp(' ')
disp('Testing Lognormality:')
disp(' ')

figure('Position',[1 scrsz(4)/(5) scrsz(3)*(2/3) scrsz(4)*(6/9)])
PROC_lognormal_test


disp('Press any key to continue')    
pause



% Linear Multifractal analysis

disp(' ')
disp('Testing Multifractal Linearity')
disp(' ')


figure('Position',[1 scrsz(4)/2 scrsz(3)*(2/3) scrsz(4)/2])
PROC_linear_multifractal_analisis

disp('Press any key to continue')    
pause

% Computing multifractal parameters beta and sigma^2

disp(' ')
disp('Computing multifractal parameters beta and sigma for a whole month, and')
disp('plotting them versus their corresponding mean rainfall values')
disp(' ')

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)*(2/3) scrsz(4)/2])


PROC_BetSig2vsmean


disp('Press any key to continue')    
pause

% Downscaling TRMM and correcting with ANUSPLINE

disp(' ')
disp('Downscaling TRMM and correcting with ANUSPLINE')
disp(' ')

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)*(2/3) scrsz(4)/2])
PROC_Downscaling


disp('Press any key to continue')    
pause

% Downscaling TRMM and correcting with ANUSPLINE

disp(' ')
disp('Exceedance plot and QQplot')
disp(' ')

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4)/(5) scrsz(3)*(2/3) scrsz(4)*(6/9)])

PROC_ECDFtemporal


disp('Press any key to end the demonstration')    
pause





% t = 0:pi/100:2*pi;
% y = exp(sin(t));
% h = plot(t,y,'YDataSource','y');
% for k = 1:0.01:10
%    y = exp(sin(t.*k));
%    refreshdata(h,'caller') 
%    drawnow
% end
