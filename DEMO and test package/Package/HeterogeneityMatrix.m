%Computing heterogeneity matrix using Pathirana & Herath algorithm 

%PATHIRANA & HERATH (2002)

% R   -->   3-dimensional matrix containing the snapshots to be processed.
%            usually A is provided by another function on the raw data. For
%            example, data from ANUSPLIN is gather in A by stack_anuspli.m


function G=HeterogeneityMatrix(R,fsize)

%  In our application label1 and label2 correspond to month and year,
%  respectively.

Rsize=size(R);

Rre=zeros(fsize,fsize,Rsize(3));

for i=1:Rsize(3)

    Rre(:,:,i) = imresize(R(:,:,i),[fsize fsize],'bilinear'); % resizing R to fsizexfsize image
    
end


A=mean(Rre,3);      % Average of snapshots through third dimension (usually this third dimension is time)

G=A/(mean2(A));    % Equation (8) in Pathirana & Herath (2002)


