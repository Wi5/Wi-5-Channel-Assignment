function assignedCh=chAssign_random(APs, parameters)
    for ap1 = 1:length(APs)
        ind0=1:parameters.nCH;
        assignedCh(ap1)=ind0(randi(length(ind0)));        
        set_CH(APs(ap1),parameters,assignedCh(ap1));        
    end
end