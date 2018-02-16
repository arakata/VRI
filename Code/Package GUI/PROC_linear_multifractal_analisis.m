%close
clear
%clc

% Initial parameters

% datafolder='data15082013';
qi=0.2;                      % Initial multifractal moment
qstep=0.2;                   % Multifractal moments step
qf=2.6;                        % Final multifractal moment 
level_scale1=3;               % number of downscaling levels to compute tau(q) multifractal function
level_scale2=8;               % number of downscaling levels to compute tau(q) multifractal function
q=qi:qstep:qf;               % Multifractal moments

% Loading data for analysis

TRMM8=load('2003_4_15.txt');

ANSP=loadStructFromFile('ANUSPLINEtestimage.mat'); %01/07/2001
%  Linear multifractal analysis



disp(' ')
disp('Multifractal linearity (3 levels) for TRMM on April 15, 2003')
disp(' ')
disp('Press any key to see the multifractal linearity plot')

pause(0.5)

subplot(1,2,1)


[logMn,loglambda]=LinearMultifractalAnalysis(TRMM8,q,level_scale1,'on');
title('TRMM $15/04/2003$ multifractal linearity','Interpreter','latex','FontSize',14)

disp(' ')
disp('Multifractal linearity (8 levels) for ANUSPLINE on January 7, 2001')
disp(' ')
disp('Press any key to see the multifractal linearity plot')

pause(0.5)

subplot(1,2,2)

[logMn,loglambda]=LinearMultifractalAnalysis(ANSP,q,level_scale2,'on');
title('ANUSPLINE $07/01/2001$ multifractal linearity','Interpreter','latex','FontSize',14)


