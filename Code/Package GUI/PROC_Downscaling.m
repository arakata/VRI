clear

% number of generated data for averaging
repetitions = 20; 

% desired final resolution of data
fsize=256;   

% number of downcaling levels. Need to agree with heterogeneity matrix (ANUSPLINE (225x225 --> 256x256))
downscale_level=5;  

% difference in resolution between original data and generated data
nupscale=2^downscale_level; 


% Parameters used in computations
Lo=28;                        % Pixel size TRMM grid.
d=2;                          % Euclidean dimension
b=4;                          % Branching parameter 
qi=0.1;                       % Initial multifractal moment
qstep=0.1;                    % Multifractal moments step
qf=3;                         % Final multifractal moment 
level_scale=3;                % Number of downscaling levels for computing beta and sigma^2
sizeq=size(qi:qstep:qf,2);    % Number of multifractal moments
qvalue=2;                     % Value of q at which beta and sigma^2 are computed
qv=num2str(qvalue);


TRMM=loadStructFromFile('testImage03162000.mat');



% Computing beta and sigma2
[bet,sig2]=CalculationBetaSig2(TRMM,qi,qstep,qf,qvalue,level_scale);

betnmr=num2str(bet);
sig2nmr=num2str(sig2);

% Downscaling data. Each snapshot is 8x8 --> 256x256. 

Downscaled = Downscaling2D(Lo,b,d,bet,sig2,TRMM,downscale_level,repetitions);


% Loading heterogeneity matrix 

load('Gmonth032000.mat')

% Correcting downscaled information
Corrected_Downscaled = Correction2D(Downscaled,G);


% Upscaling information
Upscale_Downscaled=Upscale2D(Corrected_Downscaled,nupscale);



% Showing results


disp(' ')
disp('TRMM original test image for downscaling (subplot(2,2,1)) ')
disp(' ')
pause(0.5)

subplot(2,2,1)


imagesc(TRMM)
xlabel('pixel ($\sim 28km$)','FontSize',14,'interpreter','latex');
ylabel('pixel ($\sim 28km$)','FontSize',14,'interpreter','latex');
title(['TRMM'],'FontSize',14,'interpreter','latex');
colorbar


% maximum TRMM 
Amax=max(max(TRMM));




disp(' ')
disp('Loading heterogeneity matrix (subplot(2,2,2))')
disp(' ')
pause(0.5)

subplot(2,2,2)


imagesc(G,[0,3.5]);
xlabel('pixel ($\sim 0.875km$)','FontSize',14,'interpreter','latex');
ylabel('pixel ($\sim 0.875km$)','FontSize',14,'interpreter','latex');
title(['Herogeneity Matrix'],'FontSize',14,'interpreter','latex');
colorbar




disp(' ')
disp('Downscaled TRMM (subplot(2,2,3))')
disp(' ')
disp(['The multifractal parameters are: beta=',betnmr,' and sigma square=',sig2nmr ])
disp(' ')
pause(0.5)

subplot(2,2,3)


imagesc(Downscaled,[0,Amax]);
xlabel('pixel ($\sim 0.875km$)','FontSize',14,'interpreter','latex');
ylabel('pixel ($\sim 0.875km$)','FontSize',14,'interpreter','latex');
title(['Downscaled'],'FontSize',14,'interpreter','latex');
colorbar


disp(' ')
disp('Corrected downscaled TRMM (subplot(2,2,4))')
disp(' ')
pause(0.5)

subplot(2,2,4)


imagesc(Corrected_Downscaled,[0,Amax]);
xlabel('pixel ($\sim 0.875km$)','FontSize',14,'interpreter','latex');
ylabel('pixel ($\sim 0.875km$)','FontSize',14,'interpreter','latex');
title(['Corrected'],'FontSize',14,'interpreter','latex');
colorbar










