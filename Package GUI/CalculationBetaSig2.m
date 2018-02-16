function [bet,sig2]=CalculationBetaSig2(dat,qi,qstep,qf,qvalue,level_scale)

% dat        --> 3D matrix containing snapshots (in the third dimension)

% qvalue     --> multifractal moment at which the values of bet and sig2 will be computed

% beta       --> array of beta values for each snapshot in dat

% sig2       --> array of sig2 values for each snapshot in dat

%level_scale --> number of levels for computing tau

% qi=0.1;         % Initial moment
% 
% qstep=0.1;      % Moments step
% 
% qf=3;           % Final mmoment 

q=qi:qstep:qf;                 % List of q's

%sizeq=size(q,2);

%q=q';

%n1=size(dat,1); % nbr rows TRMM
%n2=size(dat,2); % nbr columns TRMM
n3=size(dat,3); % number of snapshots trmm. This has to coincide with the number of snapshots of ANUSPLINE (actually thisis not necessarily true!!!!). 

% Computing Multifractal moment spectrum

%tau_vector=zeros(sizeq,n3);

bet=zeros(1,n3);
sig2=zeros(1,n3);

for i=1:n3
    
    % Computing vector of taus
    [tau,orden,R2]=Tau2D(dat(:,:,i),qi,qstep,qf,level_scale);
    
    % Computing parameters beta and sigma square
    [bet(i),sig2(i)]=BetaLognormalparameters(tau,q,qvalue,'central');   

end
