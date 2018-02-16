    clf
    
    KKK=0;
        
    [X,Y] = meshgrid(1:nsize(1));
    [X1,Y1,Z1] = meshgrid(1:nsize(1), 1:nsize(2), 1:nsize(3));
    lambda=zeros(Stations_number,nsize(1)*nsize(2),nsize(3));
    %lambdaPositive=zeros(nn,nsize(1)*nsize(2),nsize(3));
    for iii=1:nsize(3)
    %Corrected_Downscaled_TRMM = interp3(Corrected_Downscaled_TRMM, X1, Y1, Z1,'spline');    
    day=iii
    Z=double(ppspatial(:,:,day));
    
% Samples to construct variogrm    
    incr = 1; % 1 -> uses all pixels. We can reduce the number of samples if the images are too big
    x = X(:);
    %x=x(1:incr:end); % Here we use the increments
    y = Y(:);
    %y=y(1:incr:end); % Here we use the increments
    z = Z(:);
    %z=z(1:incr:end); % Here we use the increments

    % Points for kriging weights
    
    nnn=size(stationsLoc);
    nn=nnn(1);
    xk = stationsLoc(:,3);  % xk refers to the rows, which is the y position of the station
    yk = stationsLoc(:,2);  % yk refers to the columnss, which is the x position of the station
    for i=1:nn
    zk(i) = Z(xk(i),yk(i));
    end
    zk=zk';
    
    % calculate the sample variogram
    v = variogram([x y],z,scale,'nrbins',12,'plotit',false,'maxdist',280); % computing variogram for each day
    % Here we compute the isotropic variogram for each day. This adds some temporal heterogeneity. 
    vv(:,iii)=v.val; % recording all variograms in vv. Note that v is a structure.
    if sum(sum(Z)) == 0  % removing any day with overall zero rainfall. 
    KKK=KKK+1;    
    vstruct(day)=vstruct(day-1);  % For this zero rainfall day, we just consider the last non zero variogram  
    else
        % fitting variogram to the stable model. We can also pick other
        % models (see variogramfit function.)
        [dum,dum,dum,vstruct(day)] = variogramfit(v.distance(1:end-1),vv(1:end-1,day),[],[],[],'model','stable','nugget',0);
    end
    
    currentstations=find(nodata(:,day) == 1)';
    csize=size(currentstations);
    [Zhat,Zvar,lambdatemp] = kriging(vstruct(iii),yk(currentstations),xk(currentstations),zk(currentstations),X,Y,scale);
    lambda(currentstations,:,iii)=lambdatemp(1:end-1,:);
    end
    vvv=mean(vv,2);
%    subplot(2,2,2)
    figure(2)
    
    % fitting the average semivariogram over the whole time period
    [b(1),b(2),b(3),vstructAvg] = variogramfit(v.distance(1:end-1),vvv(1:end-1),[],[],[],'model','matern','nugget',0);
    % Observe that vstruc is the fitting of the mean semivariogram!!!
    % b(1), b(2) and b(3) are the parameters of the theoretical
    % semivariogram. b(1) is the range, b(2) is the sill and b(3) is the
    % nugget.
    
    title('Semi-variogram','Interpreter','latex','FontSize',14)
    h=legend('$Empirical$','$Theoretical$','Location','SouthEast');
    set(h,'Interpreter','latex')
saveas(h,strcat(outputfolder,'/',output,'/','Semivariogram',ppspatialside,'x',ppspatialside),'jpg');
saveas(h,strcat(outputfolder,'/',output,'/','Semivariogram',ppspatialside,'x',ppspatialside),'fig');
% Observation: WE CONSTRUCT VARIOGRAM WITH ALL THE DATA, BUT KRIGING WEIGHTS ONLY FROM STATIONS    
save(strcat(outputfolder,'/',output,'/LambdasfromSpat',ppspatialside,'x',ppspatialside,'.mat'),'lambda','-v7.3')
    