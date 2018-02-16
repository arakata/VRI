function A=Upscale2D(dat,n)

% This routine upscale 2D matrix dat by taking the mean of square 
% blocks of size n 


% n   --> block size for upscaling

% dat --> input matrix

% A   --> Upscaled data

fun = @(block_struct) mean2(block_struct.data); % computing the upscaled data (by averaging).

A = blockproc(dat,[n n],fun); 