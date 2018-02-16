

for i=1:length(coord)
    difx=abs(Lon-coord(i,1));
    minx=min(difx);
    [x]=find(difx==minx);
    x=x(1);
    
    dify=abs(Lat-coord(i,2));
    miny=min(dify);
    [y]=find(dify==miny);
    y=y(1);
    
    coord(i,3)=x;
    coord(i,4)=y;
end

stationLoc=(1:length(coord))';
stationLoc(:,2:3)=[coord(:,3:4)];
