function  [xbet,xsig2] = LogNormalParamVSmeans(xdat,betdat,sig2dat,name,fig)

% xdat    --> x axis data (TRMM means in our case)

% betdat  --> betas for each x axis data

% sig2dat --> sig2 for each x axis data

% name    --> name of period of analysis (name of month in our case Month{i})

% fig     --> number corresponding to name (month number in our case)

% calculations for bet

    h=figure(fig); 
    
    set(h, 'PaperPosition', [0 0 10 4.5]);
    
    subplot(1,2,1);
    
    hold on
    
    semilogx(xdat,betdat,'+k') 
    
    set(gca,'xscale','log')
    
    xlabel('$ r \;\; {\rm (daily\;\; TRMM\;\; mean)}$','interpreter','latex','FontSize',10); 
    
    ylab=ylabel('$ y \;\;({\rm daily}\;\; \beta)$','interpreter','latex','FontSize',10); 
    
    set(ylab, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);

    title(['$\beta\;{\rm vs\; mean\; TRMM}$',' (',name,')'],'interpreter','latex','FontSize',14);

    xdatlog=log10(xdat);
    
    % Nonlinear regression beta
     
    F = @(x,xdata)x(1).^(xdata.^x(2))+x(3); % adjusting curve betas

    x0 = [0.2 0.5 0.6];

    opts = statset('nlinfit');

    opts.RobustWgtFun = 'bisquare';
    
    [xbet] = nlinfit(xdat,bet,F,x0,opts);
    
    x1=num2str(xbet(1));
    
    x2=num2str(xbet(2));
    
    x3=num2str(xbet(3));
    
    t=0:0.01:1000;
    
    semilogx(t,F(xbet,t),'-')
    
    grid on
    
    h_legend=legend('Observed',['y',' = ',x1,'^{r','^{',x2,'}}+',x3]);
    
    set(h_legend,'Location','NorthWest')
    
    hold off
    
    
 %  Calculations for sig2    
    
    
    subplot(1,2,2);

    hold on

    semilogx(xdat,sig2dat,'+k')

    set(gca,'xscale','log')
    
    xlabel('$ r \;\; {\rm (daily\;\; TRMM\;\; mean)}$','interpreter','latex','FontSize',10); 
    
    ylab=ylabel('$ y \;\;({\rm daily}\;\; \sigma^2)$','interpreter','latex','FontSize',10); 
    
    set(ylab, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
    
    title(['$\sigma^2\;{\rm vs\; mean\; TRMM}$',' (',name,')'],'interpreter','latex','FontSize',14);
    
    % Nonlinear regression beta
     
    F = @(x,xdata)exp(x(1).*log(xdata).^2+x(2).*log(xdata)+x(3)); % adjusting curve for sig2

    x0 = [0.2 0.5 2];

    opts = statset('nlinfit');
    
    opts.RobustWgtFun = 'bisquare';
    
    [xsig2] = nlinfit(xdat,sig2dat,F,x0,opts);

    x1=num2str(xsig2(1));
    
    x2=num2str(xsig2(2));
    
    x3=num2str(xsig2(3));
    
    t=0:0.01:1000;
    
    semilogx(t,F(xsig2,t),'-')
    
    axis([ 0.001 1000 0 1]);
    
    grid on;
    
    h_legend=legend('Observed',['y',' = exp(',x1,'ln(r)^2+',x2,'ln(r)',x3,')']);
    
    set(h_legend,'Location','NorthWest')
    
    hold off
    
    