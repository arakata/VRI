%function [xtc,ttc,ggc]=ExeedenceComparisson(obs,gen,fig,sym,property)
function [xtc,ttc,ggc,stats]=ExeedenceComparisson(obs,gen,fig,sym,property)

% This routine compares, calculates and graph (Log-Log) the exceedence
% probability of obs and gen

% obs --> observed data

% gen --> generated data

% fig --> station number

% sym --> symbol for the exceedence probability of generated data

% property --> default: no confidence interval, confidence: shows
%              confidence intervals

% xtc -->  obs and gen cummulation values 

% ttc -->  exceedence probability obs

% ggc -->  exceedence probability gen (at the same values of obs)
   
% stats --> 12 x 2 matrix; first column provides statistics for observed data
%                          second column provides statistics for generated data 


if ischar(fig)
    num=fig;
else 
    num=num2str(fig);
end
   
symOBS='.';  % symbol used to draw data points in graph
    
[tt,xt]=ecdf(obs,'function','survivor');
    
loglog(xt,tt,symOBS,'color',[0.8,0.8,0.8])
    
hold on

if nargin == 4

             [gg,xg]=ecdf(gen,'function','survivor');
    
         if sum(xg == 0) > 1  % this if is because sometimes ecdf creates two 
                              % initial points (xt,tt)=(xg,gg)=(0,0)
                              % so this if removes such zero. This is a fixed in
                              % order to compute the statistics of the ECDF
                              % comparisson       
                              
            n1=size(xt,1); 
    
            n2=size(xg,1);
        
            ggc = interp1(xg(2:n2),gg(2:n2),xt(2:n1),'linear','extrap')%,'pchip');
            
            % Removing last interpolation because it leaves the range of the
            % data values
            
            ggc(n1-1)=[];
            
            ttc = tt(2:n1-1);
            
            xtc = xt(2:n1-1);
                        
         else
        
            ggc = interp1(xg,gg,xt,'linear','extrap');
        
            ttc = tt;
            
            xtc = xt;
         end
    
        loglog(xg,gg,sym,'color',[0.4,0.4,0.4]);
        h_legend=legend('Observed data','Generated data');
        set(h_legend,'Location','SouthWest')
        %num=num2str(fig);
        title(['Exceedence probability at station ',num],'Interpreter','latex','FontSize',14);
        xlabel('Rainfall amount (mm)','Interpreter','latex','FontSize',14);
        ylabel('Probability','Interpreter','latex','FontSize',14);
    
        axis([ 0.01 100 0.001 1]);    
    
        
        hold off
    
        stats=Stadigraph(obs,gen,ttc,ggc);
        
elseif nargin == 5    
        
    switch property

        case 'default'     
        
            [gg,xg]=ecdf(gen,'function','survivor');
    
            if sum(xg == 0) > 1  % this if is because sometimes ecdf creates two 
                                  % initial points (xt,tt)=(xg,gg)=(0,0)
                                  % so this if removes such zero. This is a fixed in
                                  % order to compute the statistics of the ECDF
                                  % comparisson       
                              
                n1=size(xt,1); 
    
                n2=size(xg,1);
        
                ggc = interp1(xg(2:n2),gg(2:n2),xt(2:n1),'linear','extrap');
        

                % Removing last interpolation because it leaves the range of the
                % data values
            
                ggc(n1-1)=[];
            
                ttc = tt(2:n1-1);
            
                xtc = xt(2:n1-1);
        
            else
        
                ggc = interp1(xg,gg,xt,'linear','extrap');
        
                ttc = tt;
            
                xtc = xt;
            
            end
    
            loglog(xg,gg,sym,'color',[0.4,0.4,0.4]);
            h_legend=legend('Observed data','Generated data');
            set(h_legend,'Location','SouthWest')
            %num=num2str(fig);
            title(['Exceedence probability at station ',num],'FontSize',14);
            xlabel('Rainfall amount (mm)','FontSize',14);
            ylabel('Probability','FontSize',14);
    
            axis([ 0.01 100 0.001 1]);    
    
        
            hold off
    
            stats=Stadigraph(obs,gen,ttc,ggc);
        
        case 'confidence'     
        
            [gg,xg,Lg,Hg]=ecdf(gen,'function','survivor');
    
            if sum(xg == 0) > 1  % this if is because sometimes ecdf creates two 
                             % initial points (xt,tt)=(xg,gg)=(0,0)
                             % so this if removes such zero. This is a fixed in
                             % order to compute the statistics of the ECDF
                             % comparisson       
                n1=size(xt,1); 
    
                n2=size(xg,1);
        
                ggc = interp1(xg(2:n2),gg(2:n2),xt(2:n1),'pchip');
        
                % Removing last interpolation because it leaves the range of the
                % data values
            
                ggc(n1-1)=[];
            
                ttc = tt(2:n1-1);
            
                xtc = xt(2:n1-1);

            else
        
                ggc = interp1(xg,gg,xt);
        
                ttc = tt;

                xtc = xt;
                
            end
    
            loglog(xg,gg,sym,'color',[0.4,0.4,0.4]);
    
            loglog(xg,Lg,'--r','LineWidth',1);    % Plots lower confidence interval
            loglog(xg,Hg,'--r','LineWidth',1);    % Plots higher confidence interval
    
            h_legend=legend('Observed data','Generated data','lower CI','higher CI');
            set(h_legend,'Location','SouthWest')
            %num=num2str(fig);
            title(['Exceedence probability at station ',num],'FontSize',14);
            xlabel('Rainfall amount (mm)','FontSize',14);
            ylabel('Probability','FontSize',14);
    
            axis([ 0.01 100 0.001 1]);    
    
        
            hold off
    
            stats=Stadigraph(obs,gen,ttc,ggc);
            
        case 'ecdf'
            
%            if nargout == 5
            
           [gg,xg]=ecdf(gen,'function','survivor');
    
        
            ggc = gg;
            
            ttc = tt;
            
            xtc{1} = xt;
            
            xtc{2} = xg;
            
            loglog(xg,gg,sym,'color',[0.4,0.4,0.4]);
            h_legend=legend('Observed data','Generated data');
            set(h_legend,'Location','SouthWest')
            %num=num2str(fig);
            title(['Exceedence probability at station ',num],'Interpreter','latex','FontSize',14);
            xlabel('Rainfall amount (mm)','Interpreter','latex','FontSize',14);
            ylabel('Probability','Interpreter','latex','FontSize',14);
    
            axis([ 0.01 100 0.001 1]);    
    
        
            hold off

            stats=[];%Stadigraph(obs,gen,ttc,ggc);
            
%             else
%                 
%                 error('Wrong number of input arguments')
%         
%             end
            
    end   
    
end

  
    