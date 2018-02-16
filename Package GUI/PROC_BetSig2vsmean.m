% This routine compares the values of beta\sigma^2 with respect to
% the mean of generated snapshot data for an specific month from 1999 to 2006. 

clear

%repetitions=300;  

%numrep=num2str(repetitions);

monthnumber=1;  % January

Months={'January','February','March','April','May','June','July',...
    'August','September','October','November','December'};  
     % cell array. Use curly brackets Months{i} instead of Months(i)

     
     
% generating scatter plots for specific month months from 1999-2006


% year/month/day information

load('yearmonthday');

% Extracting monthly data for the 8 years under study

load('betq1');

load('sig2q1');

year=1999; 

yearmonthdaytemp = yearmonthday(:,yearmonthday(1,:) == year);

xdat = stack2matrix3D('trmm1.txt',8,8);
    
xdat=xdat(:,:,yearmonthdaytemp(2,:) == monthnumber);
    
[xbet,xsig2] = BetSig2VSmean(bet(yearmonthday(2,:) == monthnumber ...
    & yearmonthday(1,:) == year),sig2(yearmonthday(2,:) == monthnumber ...
    & yearmonthday(1,:) == year),xdat,monthnumber,Months{monthnumber}); 

