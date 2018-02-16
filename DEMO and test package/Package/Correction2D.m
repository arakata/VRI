function A = Correction2D(dat,G)

% This routine corrects matrix dat by pointwise multiplication of matrix G
% and multiplication of mean preservation factor.

% dat --> input matrix (Downscaled TRMM matrix in our application)

% ref --> reference matrix (TRMM matrix in our application)

% G   --> correction matrix (Heterogeneity matrix)

datsize=size(dat);

if  sum(sum(dat,2),1) == 0  ||  sum(sum(G))==0

    A=zeros(datsize(1),datsize(2));
        
else    
    
    temp=dat.*G;    

    factor = mean2(dat)/mean2(temp);   % Large forcing parameter chosen such that the mean of the generated data is preserved, i.e., A = mean2(generated data) / (mean2( Generated data * Heterogeneity matrix))

    A = factor*temp;
    
    
end


