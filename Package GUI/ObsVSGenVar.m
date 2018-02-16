function   [varxdat,varydat,slopesrobust,R2robust,h]= ObsVSGenVar(xdat,ydat,fig,namefig)

% This routine compares the means of each snapshot of observed data vs the means for each snapshot of generate/simulted data 

% xdat    --> observed data (3D matrix)

% ydat    --> generated data (3D matrix)

% fig     --> figure number

% namefig --> figure identifier for title

% varxdat --> row containing variances of each snapshot in xdat

% varydat --> row containing variances of each snapshot in ydat

% h --> optional output for saving figure


%   Computing means of observed data snapshots and simulated snapshots 

    xdatsize=size(xdat);
    
    for i=1:xdatsize(3)
    
    xdattemp=xdat(:,:,i);
    varxdat(i)=squeeze(var(xdattemp(:)));
    
    end
    
    ydatsize=size(ydat);

    for i=1:ydatsize(3)
    
    ydattemp=ydat(:,:,i);
    varydat(i)=squeeze(var(ydattemp(:)));
    
    end
    
    varxdat=varxdat';
    varydat=varydat';
    
%   Robust linear fitting observed vs Simulated means

    fit_opts = fitoptions('Method', 'LinearLeastSquares', 'Robust', 'on');
    [brob, goodness2] = fit(varxdat,varydat, 'poly1', fit_opts);
    
    slopesrobust=brob.p1;
    brobp1=num2str(brob.p1);
    
    R2robust=goodness2.rsquare;
  
    R2robustnum=num2str(R2robust);
    
    if nargout == 5
    
       h=figure(fig);
    
    elseif nargout == 4
    
       figure(fig);
        
    end
    
    scatter(varxdat,varydat,'+k'); grid on; 
    
    hold on

    plot(varxdat,brob.p2+brob.p1*varxdat,'-','LineWidth',1,'color',[0.7,0.7,0.7])

    title([namefig,[', '],'R^2 = ',R2robustnum],'FontSize',14);%([Months{i},[', '],'R^2 = ',R2robustnum],'FontSize',14);
    
    xlabel('Observed variance','FontSize',14);
    
    ylabel('Simulated variance','FontSize',14);
    
    TRMMlegend=legend(namefig,['Linear fitting,',' slope=',brobp1]);%([Months{i},' data from 1999-2006'],['Robust linear fitting,',' slope=',brobp1]);
    
    set(TRMMlegend,'Location','NorthWest')
    
    hold off
    