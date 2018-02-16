function [xbet,xsig2,h]=BetSig2VSmean(bet,sig2,dat,fig,namefig)

% This routine compares the the parameters beta and sigma^2 with respect to the means of each snapshot of observed data vs the means for each snapshot of generate/simulted data 

% bet --> row containing values of beta

% sig2 --> row containing values of sigma^2

% dat    --> generated data (3D matrix)

% fig     --> figure number

% namefig --> figure identifier for title

% xbet --> parameters of nonlinear equation for beta

% xsig2 --> parameters of nonlinear equation for sigma^2


%   Computing means of generated snapshots 

datsize=size(dat);
meandat=squeeze((1/(datsize(1)*datsize(2)))*sum(sum(dat,1),2))';

    
    
%%%%%%%%%% analysis of bet and sig2 by months together with nonlinear regression
    
   
    if nargout == 3
    
       h=figure(fig);
       %set(h, 'PaperPosition', [0 0 10 4.5]);
       
    elseif nargout == 2
    
%       figure(fig);
       %set(h, 'PaperPosition', [0 0 10 4.5]);
       
    end

    
    disp(' ')
    disp('The plot for beta is:')
    disp(' ')
    pause
    
    subplot(1,2,1);
    
    hold on
    semilogx(meandat,bet,'+k') 
    set(gca,'xscale','log')
    %set(gca,'Ytick',0.2:0.2:1);
    xlabel('$ r \;\; {\rm (daily\;\; TRMM\;\; mean)}$','interpreter','latex','FontSize',10); 
    ylab=ylabel('$ y \;\;({\rm daily}\;\; \beta)$','interpreter','latex','FontSize',10); 
    set(ylab, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
    %str=num2str(corr(intensity,bet)); 
    title(['$\beta\;{\rm vs\; generated\; means}$',' (',namefig,')'],'interpreter','latex','FontSize',14);%,num2str(corr(intensity,bet))))

    % Nonlinear regression beta
     
    F = @(x,xdata)x(1).^(xdata.^x(2))+x(3);

    x0 = [0.2 0.5 0.6];

    opts = statset('nlinfit');
    opts.RobustWgtFun = 'bisquare';
    
    [xbet] = nlinfit(meandat,bet,F,x0,opts);
    x1=num2str(xbet(1));
    x2=num2str(xbet(2));
    x3=num2str(xbet(3));
    t=0:0.01:1000;
    semilogx(t,F(xbet,t),'-')
    grid on
    h_legend=legend('Observed',['y',' = ',x1,'^{r','^{',x2,'}}+',x3]);
    set(h_legend,'Location','NorthEast')
    hold off
    
    % SAVE Monthly comparisson of beta vs TRMM means !!!
%     saveas(h,strcat(datafolder,'/output1/',['TRMMmeansvsSimulatedmeans',numrep,'/betvsTRMM',Months{i},' from 1999 to 2006']),'jpg');
%     close(h)

    disp(' ')
    disp('The plot for sigma square is:')
    disp(' ')
    pause

    
    subplot(1,2,2);

    hold on

    semilogx(meandat,sig2,'+k')
    set(gca,'xscale','log')
    %set(gca,'Ytick',0:0.2:0.8);
    xlabel('$ r \;\; {\rm (daily\;\; TRMM\;\; mean)}$','interpreter','latex','FontSize',10); 
    ylab=ylabel('$ y \;\;({\rm daily}\;\; \sigma^2)$','interpreter','latex','FontSize',10); 
    set(ylab, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
    title(['$\sigma^2\;{\rm vs\; generated\; means}$',' (',namefig,')'],'interpreter','latex','FontSize',14);%,num2str(corr(intensity,bet))))
    
    % Nonlinear regression beta
     
    F = @(x,xdata)exp(x(1).*log(xdata).^2+x(2).*log(xdata)+x(3));

    x0 = [0.2 0.5 2];

    opts = statset('nlinfit');
    opts.RobustWgtFun = 'bisquare';
    
    [xsig2] = nlinfit(meandat,sig2,F,x0,opts);
    x1=num2str(xsig2(1));
    x2=num2str(xsig2(2));
    x3=num2str(xsig2(3));
    t=0:0.01:1000;
    semilogx(t,F(xsig2,t),'-')
    %axis([ 0.001 1000 0 1]);
    axis tight
    
    grid on;
    h_legend=legend('Observed',['y',' = exp(',x1,'ln(r)^2+',x2,'ln(r)',x3,')']);
    set(h_legend,'Location','NorthEast')
    
    hold off
    
    
    