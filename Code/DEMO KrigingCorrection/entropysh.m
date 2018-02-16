function [hh]=entropysh(rs)
% [hh]=entropysh(rs)
sum_rs=sum(rs);
for p=1:length(rs)
    if rs(p)<=0
        hh_rs(p,1)=0;
    else
        hh_rs(p,1)=-(rs(p)/sum_rs)*log((rs(p)/sum_rs));
    end
end
hh=sum(hh_rs);

    