function [tau,orden,R2]=Tau2D(dat,qi,qstep,qf,level_scale)

%INPUT:
%   dat         --> input data 
%   qi          --> initial order moment 
%   qstep       --> step between order values
%   qf          --> final order moment 
%   level_scale --> final level of scale =2^(i) where i=0,1,...,level_scale

%OUPUT:
%   tau         --> tau vector, i.e. tau=tau(q).
%   orden       --> son los valores de los ordenes de momentos (vector q)
%   R2          --> Coefficient of determination by each linear analysis
%                   between Log(Mn) against Log(lambda).

%% MEASURE
D=size(dat);                    % Data dimension
L=D(1);                         % largest scale of interest (initial cascade step).

b=4;   % branching parameter

d=2;   % euclidean dimension
%% SCALING PROCESS

for n=0:level_scale             % Step or level scale. n=1 is the initial step.           
    b1=2^n;                     % Ratio of scales (scale on the step n)
    b2=2^n;                     % Having b1 and b2 only makes sense if we have a rectangular matrix!
    m=[];
        
    fun = @(block_struct) sum(sum((block_struct.data))); %* ones(size(block_struct.data));
    m = blockproc(dat,[b1 b2],fun);                      % Automatically generates a lower resolution agregated 
                                                         % matrix
    Mn(n+1,:)=sum(bsxfun(@power,repmat(m(:),[1,size(qi:qstep:qf,2)]),(qi:qstep:qf)),1); % gives a row vector with each component containing
                                                                                       % the sum of the qth moment of the image at scale
                                                                                       % n 
    lambda(n+1)=b.^(-(level_scale-n)/d);         %% "lambda" is defined as the scale = ln/l0=2^(n)/1
                                                 % aqui es diferente por que esta cascada va en sentido contrario por
                                                 % eso la escala esta definida distinto va de abajo a arriba en la
                                                 % figura 3.1 de la tesis de maestria=> l0=1, y ln=16 (longitud final de la cascada)
    clear m  
end

%% tau and figure
% figure;
x=-log(lambda);
y=log(Mn);           % Here it is. When all data is zero in TRMM (corrected or not), then log returns NaN !!!! Got to fix this 
cq=0;
tyzero=zeros(level_scale+1,1)';
for q=qi:qstep:qf           
    cq=cq+1;
    if sum(Mn(:,cq)) == 0
       ty= tyzero;
       R2(cq)=-1;  %R^2 when data is 0
    else
       ty=y(:,cq)';
       R2(cq)=(corr(x',ty')).^2;  %R^2 between log(Mn) against log(lambda)
    end
%     plot(x,ty,'ok')
%    R2(cq)=(corr(x',ty')).^2;  %R^2 between log(Mn) againt log(lambda)
    rec=polyfit(x,ty,1);
    tau(cq)=rec(1);            % log(Mn)=rec(1)log(lambda)+rec(2) where Mn~landa^(tau) --> rec(1)=tau o tau=rec(1) 
    
%     hold on
    orden(cq)=q;               %orden de momento estadistico
    mty=rec(1)*x+rec(2);
%     plot(x,mty,'-k')
end
% xlabel('Log_2(\lambda)')
% ylabel('Log_2(M(\lambda,q))')
% title('Linear analysis where scale-->\lambda, and M-->Moment in the scale \lambda.')

%% Multifractal spectrum figure
% figure;
% plot(orden,tau,'o-'); 
% title('Multifractal spectrum')
% xlabel('q')
% ylabel('tau(q)')

