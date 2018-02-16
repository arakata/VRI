function w=NeighborsDist(loc,h,d,PixelSize,threshold,names)

% names  provides labels for the points to be plotted

clf

n=size(loc,1);

distloc=PixelSize*pdist2(loc(:,2:3),loc(:,2:3),'euclidean'); % dictance can be change to what the application requires

distlocNeigh=(distloc < threshold)-diag(ones(1,n)); % finding neighbors in a 50 km radius

% weight matrix "binary". Here we can modify or add the option for chosing
% different types of weight matrices

w=distlocNeigh;   

% For example:
% Tiefelsdorf, M., Griffith, D. A., Boots, B. 1999 A variance-stabilizing coding 
% scheme for spatial link matrices, Environment and Planning A, 31, pp. 165-180.

% Here the weights vary with respect to the number of neighbors that each
% point has. For instance if point "k" posses p neighbors (n1,..,np) then
% w_{k,n1} = ... = w_{k,n1} = 1/p

%%%%%%%%%%

[row,col]=find(distlocNeigh);

%%%%%%%%%%%%




hold on
plot([loc(row,2) loc(col,2)]',[loc(row,3) loc(col,3)]','r-','LineWidth',2)
scatter(loc(:,2),loc(:,3),'Marker','o','MarkerEdgeColor','k','LineWidth',2,'MarkerFaceColor',[1 1 1])
axis([0 h 0 d])
set(gca,'YDir','reverse')


if ischar(names)
   for i=1:n
      label=strtrim(char(names(i,:)));
      text(loc(i,2),loc(i,3)-5,label,'FontSize',14,'VerticalAlignment','Bottom','HorizontalAlignment','Center');
   end
else
   for i=1:n
       label=num2str(names(i)); 
       text(loc(i,2),loc(i,3)-5,label,'FontSize',14,'VerticalAlignment','Bottom','HorizontalAlignment','Center');
   end
end

hold off

