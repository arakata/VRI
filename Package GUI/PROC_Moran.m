clear
clf

% Obtaining positions 

load('stationsLocOBS19'); % loads locations of stations at original resolution (on a 8x8 grid for TRMM)

load('stationsLocGEN19'); % loads locations of points at new resolution

loc1=stationsLocOBS;

loc2=stationsLocGEN;

n=size(loc2,1);

h=256;

w=256;

Ndistance=54;

%%%%%%%%%%%%

% Computing distances between stations

distloc1=28*pdist2(loc1(:,2:3),loc1(:,2:3));


distloc2=0.875*pdist2(loc2(:,2:3),loc2(:,2:3),'euclidean');

distlocNeigh=(distloc2 < Ndistance)-diag(ones(1,n)); % finding neighbors in a 50 km radius

% weight matrix "binary"

wwContiguity=distlocNeigh;

ww=wwContiguity./repmat(sum(wwContiguity,2),1,19);

ww(isnan(ww))=0;

%%%%%%%%%%

[row,col]=find(distlocNeigh);

%%%%%%%%%%%%

% Graph of nearest neighbors

P=zeros(h,w);

indices = sub2ind([h,w], stationsLocGEN(:,2),stationsLocGEN(:,3));

P(indices)=1;

figure
subplot(1,2,1)
hold on
scatter(stationsLocGEN(:,2),stationsLocGEN(:,3),'o')
axis([0 256 0 256])
plot([stationsLocGEN(row,2) stationsLocGEN(col,2)]',[stationsLocGEN(row,3) stationsLocGEN(col,3)]','g-')
set(gca,'YDir','reverse')

title('Neighboring Station Relationship','Interpreter','latex','FontSize',14)
xlabel('$x$ position','Interpreter','latex','FontSize',14)
ylabel('$y$ position','Interpreter','latex','FontSize',14);


hold off


load('StationsInfo');
load('StationSimulated10')



%%%% Need to remove TAMBOPATA!!!! so we only conside 18 station hereafter.

ww=ww(1:18,1:18);

istep=1;

for i=1:istep:2922

    
dat=sum(StationsLocal(1:18,1:i),2); % 19 dimensional vector of information (one per station)

dat1=sum(StationCorrectedSeries(1:18,1:i),2); % 19 dimensional vector of information (one per station)

% Computing Moran's index using binary weight marix based on distance between points to defines neighbors

datCenter=dat-mean(dat);
datCenter1=dat1-mean(dat1);

MoranObserved(i)=n*sum(sum(ww.*(datCenter*datCenter')))/((datCenter'*datCenter)*sum(sum(ww)));
MoranSimulated(i)=n*sum(sum(ww.*(datCenter1*datCenter1')))/((datCenter1'*datCenter1)*sum(sum(ww)));

end


subplot(1,2,2)

hold on
plot(MoranObserved,'b')

plot(MoranSimulated,'r')
title('Moran index daily accumulation','Interpreter','latex','FontSize',14)
xlabel('days','Interpreter','latex','FontSize',14)
ylabel('Index value','Interpreter','latex','FontSize',14);
legend('Observed','Generated')

hold off
