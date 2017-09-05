function assignedCh=chAssign_opt(APs, parameters)
list=1:length(APs);
ordered=[1];
while(length(list)>1)
    ref=list(1);
    comp=list; comp(1)=[];
    [~, ap]=orderAPs(APs, ref, comp, parameters);
    ordered=[ordered ap];
    list(1)=[];
    list(find(list==ap))=list(1);
    list(1)=ap;
end
APs=APs(ordered);

% list=2:length(APs);
% [ordered, ~]=orderAPs(APs, 1, list, parameters);
% APs=APs([1; ordered]);

G_temp=zeros(length(APs),length(APs));
for ap1 = 1:length(APs)
    for ap2 = 1:length(APs)
        if strcmp(parameters.APlayout,'imported')
            pwr = 10.^(([APs(ap1).tx_pwr] - parameters.importedAPpathLoss(ap1,ap2))/10); %%% %%%% imported path loss is taken as the distance representative
        else
            d = pdist2([APs(ap1).location], [APs(ap2).location]);
            pwr = 10.^(([APs(ap1).tx_pwr] - 10*log10((4*pi/3e8*[APs(ap1).freq].*d).^parameters.LossExp))/10);
        end
        pwr(pwr==Inf)=0;
        G_temp(ap1,ap2)=pwr > parameters.graphThresh;
    end
end
tempCH=[1,6,11];
for ap1=1:min(length(APs), 3)
    assignedCh(ap1)=tempCH(ap1);
    set_CH(APs(ap1),parameters,assignedCh(ap1));
end
list=1:min(length(APs), 3);
for ap1=list
    for f1 = 1:parameters.nCH
        list2=list;
        list2(ap1)=[];
        temp=0;
        for ap2=list2
            f2=APs(ap2).CHn;
            if strcmp(parameters.APlayout,'imported')
                pwr = 10.^(([APs(ap1).tx_pwr] - parameters.importedAPpathLoss(ap1,ap2))/10); %%% %%%% imported path loss is taken as the distance representative
            else
                d = pdist2(APs(ap1).location, APs(ap2).location);
                pwr = 10.^(([APs(ap1).tx_pwr] - (10*parameters.LossExp*(log10(d)+log10(parameters.freq(f1)))-147.55))/10);%10*log10((4*pi/3e8*[f1].*d).^parameters.nLoss))/10);
            end
            pwr(pwr==Inf)=0;
            pwr(pwr < parameters.graphThresh)=0;
            temp(ap2) = parameters.I_coef(f1,f2).*pwr;
            temp(ap2) = parameters.orthogCoef(f1)*temp(ap2);
        end
        temp(temp==0)=[];
        if ~isempty(temp)
            I_temp(ap1,f1)= mean(temp);
        else
            I_temp(ap1,f1)= 0;
        end
    end
end

for ap1 = 4:length(APs)
    for f1 = 1:parameters.nCH
        for ap2=1:max(ap1-1,1)
            f2=APs(ap2).CHn;
            if strcmp(parameters.APlayout,'imported')
                pwr = 10.^(([APs(ap1).tx_pwr] - parameters.importedAPpathLoss(ap1,ap2))/10); %%% %%%% imported path loss is taken as the distance representative
            else
                d = pdist2(APs(ap1).location, APs(ap2).location);
                pwr = 10.^(([APs(ap1).tx_pwr] - (10*parameters.LossExp*(log10(d)+log10(parameters.freq(f1)))-147.55))/10);%10*log10((4*pi/3e8*[f1].*d).^parameters.nLoss))/10);
            end
            pwr(pwr==Inf)=0;
            pwr(pwr < parameters.graphThresh)=0;
            temp(ap2) = parameters.I_coef(f1,f2).*pwr;
            temp(ap2) = parameters.orthogCoef(f1)*temp(ap2);
        end
        temp(temp==0)=[];
        if ~isempty(temp)
            I_temp(ap1,f1)= mean(temp);
        else
            I_temp(ap1,f1)= 0;
        end
    end
    G=G_temp(1:ap1,1:ap1);
    I=I_temp;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N=size(G,1);
    F=size(I,2);
    c=zeros(N*F,1);
    for i=1:N
        for j=1:F
            c(j+(i-1)*F,1)=sum(G(:,i).*I(i,j));
        end
    end
    
    Aeq=reshape(repmat(reshape(eye(N,N)',1,[]),F,1),[],size(eye(N,N),1))';
    beq=ones(N,1);
    
    lb=zeros(N*F,1);
    ub=ones(N*F,1);
    
    %     xmin = intlinprog(c,[1:length(c)],[],[],Aeq,beq,lb,ub);
    xmin = linprog(c,[],[],Aeq,beq,lb,ub);
    Assignment=(reshape(xmin,F,N))';
    
    sum(Assignment,1);
    for kk=4:N
        ind0=find(Assignment(kk,:)==max(Assignment(kk,:)));
        ind=find(parameters.orthogCoef(ind0)==min(parameters.orthogCoef(ind0)));
        assignedCh(kk)=ind0(ind(randi(length(ind))));
        set_CH(APs(kk),parameters,assignedCh(kk));
    end
end
end
