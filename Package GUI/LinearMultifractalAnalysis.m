function [logMn,loglambda,R2]=LinearMultifractalAnalysis(dat,q,level_scale,property)


%clf

%INPUT:
%   dat         --> input data 
%   qi          --> initial order moment 
%   qstep       --> step between order values
%   qf          --> final order moment 
%   level_scale --> number of cascade steps for the analysis

%OUPUT:
%   tau         --> tau vector, i.e. tau=tau(q).
%   orden       --> son los valores de los ordenes de momentos (vector q)
%   R2          --> Coefficient of determination by each linear analysis
%                   between Log(Mn) against Log(landa).


% Multifractal moments calculation

nq=size(q,2);

Mn=zeros(level_scale+1,nq);

lambda=zeros(level_scale+1,1);

for i=0:level_scale             
    
    b1=2^i;                     
    
    b2=2^i;                     
    
    fun = @(block_struct) sum(sum((block_struct.data))); %
    
    % Generating a lower resolution agregated matrix
    m = blockproc(dat,[b1 b2],fun);                     
    
    % Computing a row vector with each component containing the sum of the qth moment of the data at scale n
    
    % Remark: for q negative if there are 0's, there will be Inf values.
    % Here we have replace them with 0's. Need to check that that is
    % correct!!

            
    
    Mntemp=bsxfun(@power,repmat(m(:),[1,nq]),q);
    Mntemp(~isfinite(Mntemp))=0;
    
    Mn(i+1,:)=sum(Mntemp,1);
   
    lambda(i+1)=2.^(level_scale-i);         % current scale = ln/l0=2^(n)/1
                                
end

% Generating linear multifractal analysis figure

loglambda=log2(lambda);
logMn=log2(Mn);

maxMn=max(max(logMn));
minMn=min(min(logMn));

switch property
    case 'on' % provides graph

        hold on
        
        plot(loglambda ,logMn,'o','MarkerSize',5,'Color',[0.4 0.4 0.4]);
        
        xlim([-2 level_scale+1]) %axis=[];
        
        for i=1:nq
            
            qnum=num2str(q(i));
            text(loglambda(level_scale+1)-1.2,logMn(level_scale+1,i)+0.3,['q=',qnum],'HorizontalAlignment','left');
        
        end
        
        
        for j=1:nq
    
            y=logMn(:,j);

            [mx]=polyfit(loglambda,y,1);
            
            my=mx(1)*loglambda+mx(2);
            
%             
%             yresid = y - my;
% 
% 
%             SSresid = sum(yresid.^2);
% 
%             SStotal = (length(y)-1) * var(y);
%             
%             rsq = 1 - SSresid/SStotal;
% 
%             rsquare(y,my)

            RR=corrcoef(y,my);
                        

                 R2(j)=RR(1,2);

            plot(loglambda,my,'--','LineWidth',1.2,'Color',[0.7 0.7 0.7]);
        end
        
qk=find(single(q) == single(1));   % Position of 1 in q. 

%nqk=size(qk)

if ~isempty(qk)
        
        R2(qk)=1;
        
end
        
        hold off
        ylim([minMn-2 maxMn+2])
        xlabel('$Log_2(\lambda_n)$','Interpreter','latex','FontSize',14)
        ylabel('$Log_2(M_n(q))$','Interpreter','latex','FontSize',14)
        title('Linear Multifractal analysis','Interpreter','latex','FontSize',14)
    
    case 'off' % omits graph
        
        
        
end
