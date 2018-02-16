function [bet,sig2]=BetaLognormalparameters(tau,q,qvalue,derivative_type)

% bet and sig2 --> These are the parameters of a beta-lognormal distribution 

% q      --> row providing the list of multifractal moments to be used in the computation 

% qvalue -->  this is the desired value of q at which derivatives (discrete) of the function

% tau(q) will be computed.

% tau    --> This is an array providing the values of the multifractal function tau(q)

% Derivative_type --> can be 'central', 'backward' or 'forward' 

S=size(q');


qstep=q(2)-q(1);

qk=find(single(q) == single(qvalue));   % Position of qvalue in q. qk must be a point in the array q.

switch    derivative_type
    case 'central'
        
        % First derivative

        dtauC = (tau(3:S(1)) - tau(1:S(1)-2))./(2*qstep); 

        dtau = dtauC(qk-1);

        % Second derivative

        S2=S(1)-2;

        dtau2C = (dtauC(3:S2) - dtauC(1:S2-2))./(2*qstep); 

        dtau2 = dtau2C(qk-2);

    case 'backward'
        
        % First derivative

        dtauB = diff(tau)./diff(q);

        dtau = dtauB(qk-1);

        % Second derivative
        
        S2=S(1)-1;

        dtau2B = diff(dtauB)./diff(q(2:S2+1));

        dtau2 = dtau2B(qk-2);

    case 'forward'

        % First derivative 
        
        dtauF = diff(tau)./diff(q);

        dtau = dtauF(qk);
       
        % Second derivative
        
        S2=S(1)-1;
        
        dtau2F = diff(dtauF)./diff(q(2:S2+1));

        dtau2 = dtau2F(qk+1);
        
end   


% Formulas for parameters beta and sig2
d=2;                                        % Euclidean dimension
b=4;                                        % branching number. Isn't it 4 ? CY wrote b=2. So data that was obtained by the original program should be wrong ?
sig2=abs((dtau2)/(d*log(b)));               
bet=1+(dtau/d)-(sig2*log(b)*(((2*qvalue)-1)/2));  








