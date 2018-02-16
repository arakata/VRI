function [M]=Stadigraph(x,y,tt,gg)
% x=T'; y=G(:,5);

%% para x
M(1,1)=hurst(x);
M(2,1)=mean(x);
M(3,1)=min(x);
M(4,1)=max(x);
M(5,1)=skewness(x);
M(6,1)=quantile(x,0.25);
M(7,1)=quantile(x,0.5);
M(8,1)=quantile(x,0.75);
M(9,1)=var(x);

%% para y
M(1,2)=hurst(y);
M(2,2)=mean(y);
M(3,2)=min(y);
M(4,2)=max(y);
M(5,2)=skewness(y);
M(6,2)=quantile(y,0.25);
M(7,2)=quantile(y,0.5);
M(8,2)=quantile(y,0.75);
M(9,2)=var(y);

%%  The following statistics are with respect to the ECDF curves !!

M(10,1)=mean(abs(gg-tt)); %mean(gg)/mean(tt);  % mean absolute error 
M(11,1)=sqrt(mean((tt-gg).^2));%/(mean(tt)*mean(gg));   % root mean square error
corrtemp=corrcoef(tt,gg);
M(12,1)=corrtemp(1,2);   % correlation 

M(13,1)=(sum(abs(gg-tt))/sum(tt))*100;  % percentage bias
M(14,1)=nashsutcliffe(tt,gg); % Nash-Sutclieffe efficiency coefficient
M(15,1)=sqrt(mean((tt-gg).^2))/std(tt);

M(10,2)=M(10,1);
M(11,2)=M(11,1);
M(12,2)=M(12,1);
M(13,2)=M(13,1);
M(14,2)=M(14,1);
M(15,2)=M(15,1);

%M(12,1)=corr(x,y);
%save('M.txt','M','-ascii')