function [nw,hh_diffper,stat]=nhhlevel(rain0,signal0,maxLevel,mwave)


% [nw]=nhhlevel(rain0,ndvi0,dhmx,mwave)
% [nw0,hh_diff]=nhhlevel(rain0(:,nws),trmm0(:,nws),5,mwave);



%% Entropy calculation rain0 and signal0
[hh_rrr]=entropysh(rain0);
[hh_sss]=entropysh(signal0);
%%
rain1=rain0;
signal1=signal0;
hh_r=[];
hh_s=[];
%% Entropy calculation for 6 decomposition levels

for n=1:maxLevel
    [car,cdr]=dwt(rain1,mwave);
    
    [cas,cds]=dwt(signal1,mwave);
    
    [hh_rr]=entropysh(car);
    [hh_ss]=entropysh(cas);
    
    cartemp{n}=car;
    
    subplot(maxLevel,2,2*(n-1)+1)
    plot(car)
    nnn=num2str(n);
    grid on
    title(['Level ',nnn],'interpreter','latex')
    castemp{n}=cas;
    subplot(maxLevel,2,2*(n-1)+2)
    plot(cas)
    title(['Level ',nnn],'interpreter','latex')
    grid on    
    
    stat.rmse(n)=sqrt(mean((cas-car).^2));
    stat.rmsestd(n)=sqrt(mean((cas-car).^2))/sqrt(std(cas)*std(car));
    stat.nash(n)=nashsutcliffe(cas,car);   
    corrtemp=corrcoef(cas,car);
    stat.correl(n)=corrtemp(1,2);
    
    
    hh_r=[hh_r hh_rr];
    hh_s=[hh_s hh_ss];
    clear rain1 signal1
    rain1=car;
    signal1=cas;
    clear car cdr cas cds
end

hh_rain=[hh_rrr hh_r]';
hh_signal=[hh_sss hh_s]';
hh_diffper=((hh_rain-hh_signal)./hh_rain)*100;

%figure(1);plot(hh_rain); hold on; plot(hh_signal,'-r');

% for nn=2:length(hh_diffper)
%     % Se utilizo el criterio de utilizar el nivel de descomposicion cuando
%     % la diferencia de entropia entre las senales analizadas se vuelve mayor a la
%     % mitad de diferencia inicial (de las senales de aplicar wavelets),... 
%     % ....no encontre mayor referencia para esto ... asi que se puede modificar!!
%     if abs(hh_diffper(nn))>=dhmx;
%         nw=nn;
%     end
% end

%%% added by Luis A. Duffaut Espinosa - Minimum entropy difference
hh_diffper=abs(hh_diffper);
nw=find(hh_diffper == min(hh_diffper));
