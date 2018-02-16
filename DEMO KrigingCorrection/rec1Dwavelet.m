function [rec_rain]=rec1Dwavelet(rain,signal,nw,mwave,fsc)
%[rec_rain]=wavereco1d(rain,signal,nw,'haar','mnmx')
%fsc='mnmx' or 'lnrg'

%% Aplicacion de la transformada wavelet para "nw" niveles
[cr,lr]=wavedec(rain,nw,mwave);
[cs,ls]=wavedec(signal,nw,mwave);
% Definicion de la base al nivel "nw"
base_s=cs(1:ls(1));
base_r=cr(1:lr(1));


% Aplicacion del factor de escala seleccionado (mnmx o lnrg)
if strcmp(fsc,'mnmx')
    minbase_r=min(base_r);
    maxbase_r=max(base_r);
    minbase_s=min(base_s);
    maxbase_s=max(base_s);

    m=(maxbase_r-minbase_r)/(maxbase_s-minbase_s);
    b=maxbase_r-(m*maxbase_s);
    base_sr=base_s*m+b;

elseif strcmp(fsc,'lnrg')
    cxy=polyfit(base_s,base_r,1);
    base_sr=base_s*cxy(1)+cxy(2);

end

% Definicion del detalle del nivel "nw"
detail_r=cr(ls(1)+1:ls(1)+ls(2));

% Proceso de reconstruccion wavelet

reco1=[];

for i=1:nw
    
    nreco1=size(reco1);
       
    if nreco1(1) > ls(i+1)
       
        base_sr(end)=[];
        
%     elseif nreco1(1) < ls(i+1)
%         
%         base_sr=[base_sr ; 0];
                
    end
        
    reco1=idwt(base_sr,detail_r,mwave);
    
    if mwave=='haar'
        
        detal_rPos0temp=find(detail_r == 0);
        detal_rPos0=[2.*detal_rPos0temp-1 2.*detal_rPos0temp];
        reco1(detal_rPos0) = 0;
        
%         for ii=1:length(base_sr)
%            if detail_r(ii) == 0.0 % la No variacion de la lluvia (99% de los casos cuando pp es 0) provoca que el ruido sea 0
%                reco1(2*ii-1:2*ii)=0.0;
%            end
%         end
        
    elseif mwave=='sym2'

        
        for ii=1:length(detail_r)-1
           if detail_r(ii) == 0.0 
               reco1(2*ii-3:2*ii)=0.0;
           end
        end  
    end

    % negative values become 0
    
    reco1(reco1 < 0)=0;
    
%     for w=1:length(reco1)
%         if reco1(w)<0 % se eliminan los valores negativos.
%             reco1(w)=0;
%         end
%     end    

    clear base_sr detail_r
    if i<nw
        detail_r=cr(sum(ls(1:i+1))+1:sum(ls(1:i+1))+ls(i+2));
    end
    base_sr=reco1;
end

rec_rain=base_sr;


