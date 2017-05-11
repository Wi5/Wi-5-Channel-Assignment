function [Rb_STA, Rb_prev] = available_bitrate(selected_AP, STA_ID, APs, STAs, parameters)

AtchdSTAs=STAs([APs(selected_AP).AtchdSTAs, STA_ID]);
nAtchdSTAs=length(AtchdSTAs);
Rb=zeros(1,nAtchdSTAs);


XY_APs=reshape([APs(:).location],2,[])';
XY_STAs=reshape([AtchdSTAs(:).location],2,[])';
d=pdist2(XY_APs,XY_STAs);
d(d==0)=0.1;

tx_pwr=repmat([APs(:).tx_pwr]',1,nAtchdSTAs);
tx_pwr(selected_AP,1:end-1) = APs(selected_AP).perSTA_txPwr;
freq=repmat([APs(:).freq]',1,nAtchdSTAs);

RSS_temp = 10.^((tx_pwr - (10*parameters.LossExp*(log10(d)+log10(freq))-147.55))/10);
RSS_temp(RSS_temp==Inf)=max(max(RSS_temp)) + 1;

intf_temp=RSS_temp;
CHn=[APs(:).CHn];
CHn_selected_AP=APs(selected_AP).CHn;
intf_temp = intf_temp.*repmat(parameters.I_coef(CHn_selected_AP,CHn)',1,nAtchdSTAs);

intf_temp(selected_AP,:)=0;

RSS=RSS_temp(selected_AP,:);
intf=sum(intf_temp,1);

sinr=RSS./(parameters.noise+intf);
SINR=10*log10(sinr);

channel_capacity=parameters.BW*log2(1+sinr);
system_capacity=parameters.maxRate/nAtchdSTAs;

ind_less = find(channel_capacity <= system_capacity);
Rb(ind_less) = channel_capacity(ind_less);
%%%% adopt the values to OFDM values
for ss=ind_less
    ind = find((parameters.OFDM_MDR - Rb(ss)) > 0, 1);
    if isempty(ind)
        Rb(ss) = parameters.OFDM_MDR(length(parameters.OFDM_MDR));
    elseif ind > 2
        Rb(ss) = parameters.OFDM_MDR(ind-1);
    end
end

ind_more = find(channel_capacity > system_capacity);
Rb(ind_more) = (parameters.maxRate - sum(Rb))/length(ind_more);
%%%% adopt the values to OFDM values
for ss=ind_more
    ind = find((parameters.OFDM_MDR - Rb(ss)) > 0, 1);
    if isempty(ind)
        Rb(ss) = parameters.OFDM_MDR(length(parameters.OFDM_MDR));
    elseif ind > 2
        Rb(ss) = parameters.OFDM_MDR(ind-1);
    end
end

Rb_STA=Rb(end);
Rb_prev=Rb(1:end-1);
end