function A=stack2matrix3D(name,n,m)

% A is a 3D matrix

%  name is either a file name or a matrix input. 

%  This function takes the stack data (image of days one after the other 
%  with no space in between days) and rearreanges it into a 3D matrix where
%  the third dimension numbers the days.
%  We require the knowledge of the individual imaga size (# of pixels)
%  provided as inputs (m,n), which are the number of rows and columns,
%  respectively.

if isstr(name)
    M=load(name);
    [m1,m2]=size(M);
    ndays=m1/m2;
else
    M=name;
    [m1,m2]=size(M);
    ndays=m1/m2;
end

A=zeros(n,m,ndays);

for i=1:ndays
    A(:,:,i)=M(n*(i-1)+1:n*(i),:);
end
