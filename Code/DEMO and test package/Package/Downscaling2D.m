function Downscaled_A=Downscaling2D(Lo,b,d,bet,sig2,A,N,repetitions)

% Lo --> The matrix scale, i.e. each pixel has an area (Lo)x(Lo) km^2

% d --> dimension (in tis case d=2 Euclidean dimension)

% A  --> Matrix representing the information being downscaled (it represent VOLUME!!! not density or intensity)

% b  --> branching parameter. # of pieces a pixel is divided. In this case b=4. 

% Obs: the beta and sigma^2 are  obtained from the Multifractal spectrum.
% So the same LogNormal generator applies to all pixels in the matrix to be
% downscaled !!  


% Only nonzero pixels will be downscaled since when Ro is zero any lower
% resolution will still be zero.

S=size(A);

AN=kron(A,ones(2^N,2^N));  
ANsize=size(AN);

Lf=Lo/(2^N);

% Recall that what it is being downscaled is the "volume" so Ro (original
% rainfall value) gives volume Vo = Ro*Lo^2 => this reduces to volume
% Vf=Ri*Lf^2 therefore Ri=Vf/Lf^2

w=zeros(ANsize(1),ANsize(2),N);

if sum(sum(A,2),1) == 0
    Downscaled_A=zeros(ANsize(1),ANsize(2));
else 
    Downscaled_A=zeros(ANsize(1),ANsize(2));
    % repeats the proces and gives the average of the generations. The repetitions are set to 300
    for j=1:repetitions
    

            % REMARK: There are cases in which prod(w,3) = 0  (line 52). This happen for
            % probabilistic reasons. However, this causes a gauged TRMM downscaled matrix to 
            % be a zero matrix even when there exist data. However, eliminating this cases 
            % by simply generating another nonzero w matrix instead DOES affect the
            % statistics of our procedure (it alter the mean rainfall mean). 
            % The problem is that one ALWAYS expect data after downscaling when gauged TRMM is non zero.
            % this tells us that we ALWAYS have to generate more than one
            % downscaled sample and take the mean. 
            % CONSULT THIS WITH Drs, Posadas and Quiroz.
        
    %    while sum(sum(prod(w,3))) == 0
 
            for i=1:N        
        
                w(:,:,i)=kron(LogNormrand(b,bet,sig2,S(1)*2^i,S(2)*2^i,'zeros'),ones(2^(N-i),2^(N-i))); % weight matrices with generation of zeros

            end
    
    %    end        
    
        Downscaled_A = Downscaled_A +((AN)*(Lo^d)*b^(-(N)).*prod(w,3));  % Gives the downscaled measure! not volume, which would be ANV=Lo^d*Downscaled_A. 
                                                                         % So the height is given by the
                                                                         % values in AN, and the area
                                                                         % of the pixel with size Lo. Ater N steps the pixel size reduces to (Lo^2)*b^(-N) 
    end
Downscaled_A = (Downscaled_A/repetitions)/(Lf^d);              % Dividing by the area of the pixel after 
                                                               % n cascade
                                                               % steps to produce rainfall rate! (As in TRMM data)
                                                               
end