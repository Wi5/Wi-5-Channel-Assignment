function [RSS_temp, SINR, SINRdB, ch_cap] = getPwrPara(locations, APs, parameters)
nSTAs=size(locations,1);
nAPs=length(APs);
XY_APs=reshape([APs(:).location],2,[])';
d=pdist2(XY_APs,locations);
d(d==0)=0.1;

tx_pwr=repmat([APs(:).tx_pwr]',1,nSTAs);
freq=repmat([APs(:).freq]',1,nSTAs);

RSS_temp = 10.^((tx_pwr - (10*parameters.LossExp*(log10(d)+log10(freq))-147.55))/10);
RSS_temp(RSS_temp==Inf)=max(max(RSS_temp));

for ap=1:nAPs
    
    intf_temp=RSS_temp;
    CHn=[APs(:).CHn];
    CHn_selected_AP=APs(ap).CHn;
    intf_temp = intf_temp.*repmat(parameters.I_coef(CHn_selected_AP,CHn)',1,nSTAs);
    
    intf_temp(ap,:)=0;
    RSS=RSS_temp(ap,:);
    intf=sum(intf_temp,1);
    
    SINR(ap,:)=RSS./(parameters.noise+intf);
    SINRdB(ap,:)=10*log10(SINR(ap,:));
    ch_cap(ap,:)=parameters.BW*log2(1+SINR(ap,:));
end
end

