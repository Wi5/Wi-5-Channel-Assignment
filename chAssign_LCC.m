function assignedCh=chAssign_LCC(APs, parameters)
for ap1 = 1:length(APs)
    LCC_table=zeros(1,parameters.nCH);
    for ap2 = 1:max(1,ap1-1)
        if strcmp(parameters.APlayout,'imported')
            pwr = 10.^(([APs(ap1).tx_pwr] - parameters.importedAPpathLoss(ap1,ap2))/10); %%% %%%% imported path loss is taken as the distance representative
        else
            d = pdist2([APs(ap1).location], [APs(ap2).location]);
            pwr = 10.^(([APs(ap2).tx_pwr] - 10*log10((4*pi/3e8*[APs(ap2).freq].*d).^parameters.LossExp))/10);
        end
        pwr(pwr==Inf)=0;
        pwr(pwr < parameters.graphThresh)=0;
        LCC_table(1,APs(ap2).CHn) = LCC_table(1,APs(ap2).CHn) + pwr ;
    end
    ind0=find(LCC_table(1,:)==min(LCC_table(1,:)));
    ind=find(parameters.orthogCoef(ind0)==min(parameters.orthogCoef(ind0)));
    assignedCh(ap1)=ind0(ind(randi(length(ind))));
    
    set_CH(APs(ap1),parameters,assignedCh(ap1));
end
end