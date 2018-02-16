function W=LogNormrand(b,bet,sig2,n,m,name);
% PROCESS
% b=4; % scaling parameter. For rainfall rate b=4.

x=randn(n,m);      % standard normal number 

switch name
    case 'zeros'
        Wlognorm=b.^(bet-(sig2*(log(b))*0.5)+x.*(sqrt(abs(sig2)))); %variable lognormal

        Wzero=binornd(1,b^(-bet),n,m);

        W=Wlognorm.*Wzero;

    case 'nozeros'
        
        W=b.^(bet-(sig2*(log(b))*0.5)+x.*(sqrt(abs(sig2))));        %variable lognormal        

end
        
% One could use directly the lognormal generator from MATLAB functions