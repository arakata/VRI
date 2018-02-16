% Lognormal test TRMM


% loading data to be tested. Here we chose 30x30 TRMM data  
A=load('2003_4_15.txt');

disp(' ')
disp('Lognormality of TRMM on January 15, 2003')
disp(' ')

disp('Press any key to see the TRMM image')
pause(0.5)

subplot(2,2,1)



imagesc(A)
title('TRMM $30\times 30$ pixel $\sim 28km$ - $15/04/2003$','Interpreter','latex','FontSize',14)

% stacking the columns of matrix A
Ac=A(:);    

% since this is a log-normal test, we need to remove zeros.
Ac(Ac == 0)=[];  

% transforming data from log-normal to normal
Ac_normal=log(Ac);

disp(' ')
disp('Press any key to see the normal plot')
pause(0.5)
% normal plot


subplot(2,2,3)
normplotmodif(Ac_normal)
title('TRMM normal probability plot','Interpreter','latex','FontSize',14)


% Lognormal test ANUSPLINE

disp(' ')
disp('Lognormality of ANUSPLINE on January 7, 2001')
disp(' ')
disp('Press any key to see the ANUSPLINE image')
pause(0.5)

    
ANSP=loadStructFromFile('ANUSPLINEtestimage.mat'); %01/07/2001
subplot(2,2,2)
imagesc(ANSP)
title('ANUSPLINE $256\times 256$ pixel $\sim 0.875km$ - $07/01/2001$','Interpreter','latex','FontSize',14)


disp(' ')
disp('Press any key to see the normal plot')
disp(' ')
pause(0.5)


subplot(2,2,4)

Ac=ANSP(:);

% stacking the columns of matrix A
%Ac=Atemp(:);    

% since this is a log-normal test, we need to remove zeros.
Ac(Ac <= 0.01)=[];  

% transforming data from log-normal to normal
Ac_normal=log(Ac);
Ac_normal(Ac_normal < -3) =[];
Ac_normal(Ac_normal > 3.5) =[];

% normal plot
normplotmodif(Ac_normal)
title('ANUSPLINE normal probability plot','Interpreter','latex','FontSize',14)