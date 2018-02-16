%%% Reading data
    clear
         
    outputfolder='07-Apr-2016';%datestr(now,1);
    output='outputcorrectionkrigingwavelet';
    mkdir(strcat(outputfolder,'/',output));
    yi=2005; yf=2008;
    
    %% Defining weather stations data 
    out=[6 9 12 15 16 41];   %%2005 %% if any is outside of the study area
    %out=[3 5 9 11 16 19 44];
    names=char(loadStructFromFile(strcat('names')));
    outt1 = randperm(length(names));
    out1 = outt1(1:round(length(names)/15));   %% random validation stations
    out1 = [32 40 22];                             %% defined validation stations
    names1= names;
    names1(out,:)=[];  %% validation stations
    names([out out1],:)=[];  %% validation stations
    
    stationsLoc=loadStructFromFile(['stationLoc']);
    stationsLoc1=stationsLoc;
    stationsLoc([out out1],:)=[]; % remove stations 10 23 25 27 because they are outside the area. Stations 1 and 31 are removed for cross validation
    stationsLoc1(out,:)=[];
    
    %%% Select a starting date.
    startDate = datenum('03-01-2005');
    %%% Select an ending date.
    endDate = datenum('09-30-2005');   %%% xq mayo??
    endDate1 = datenum('10-01-2008');
    
    %%%%%
    %Accounting for stations with missing data!!
    yearmonthday=loadStructFromFile(strcat('yearmonthday20052008_MarchSept')); % March to Sept
    %yearmonthday(419:428,:)=[];
    yearmonthday(209:end,:)=[];  %%% change
    
%    yearmonthday=loadStructFromFile(strcat('yearmonthday20052009_7months')); % March to Sept
    %yearmonthday(2105:end,:)=[];
    yearmonthday1=loadStructFromFile(strcat('yearmonthday20052008'));
    %yearmonthday1(5249:end,:)=[];
    ntemp=size(yearmonthday,1);
    nymd1=size(yearmonthday1);

    for i=1:ntemp
        pos(i)=find(yearmonthday1(:,1) == yearmonthday(i,1) & yearmonthday1(:,2) == yearmonthday(i,2) & yearmonthday1(:,3) == yearmonthday(i,3));
    end
    
    rainall=loadStructFromFile(strcat('stationsdata'));    % loading the positions at which the stations are located in TRMM data and ANUSPLIN data
    rainall=rainall(pos,:);
    rain0=rainall;
    rainall(:,out)=[];
    rain0(:,[out out1])=[];
    rain0=rain0';
    rainall=rainall';
    nodata=rain0 >= 0;
   
    %stationsLocOBS=stationsLocOBS([out out1],:); %???
    Stations_number = size(rain0,1);
    Stations_number1 = size(rainall,1);
    
    %% Remote sensing data
    RSdata='TAMSAT';
    ppspatial=[];
    scale=4;       %%%%% resolution of data in kilometers    %%%%%%%%%%cambiar
    for i=yi:yf      %%%%%%%% YEARS    
    istr=num2str(i);    
    ppspatialtemp=loadStructFromFile(['remotesensingdata/tamsat_',istr,'MarchSept.mat']);   %% change!!
    ppspatial=cat(3,ppspatial,ppspatialtemp);
    end
    ppspatial(:,:,209:end)=[];  %%% change;  
    ppspatial=double(ppspatial);
    nsize=size(ppspatial);
    ppspatialside=num2str(nsize(1));
    
    %% Wavelet parameters
    mwave='sym2';%'haar';%'sym2'
    fsc='mnmx';
    maxLevel=6;
