function [ToBeAssigned_list, ToBeAssigned_AP]=orderAPs(APs, ref, ToBeAssign_list, parameters)
for ii=1:length(ToBeAssign_list)
    if strcmp(parameters.APlayout,'imported')
        ind(ii) = parameters.importedAPpathLoss(ref, ii); %%%% imported path loss is taken as the distance representative for ordering the AP list
    else
        ind(ii) = pdist2([APs(ref).location], [APs(ToBeAssign_list(ii)).location]); %%%%%% use distance for ordering the AP list
    end
end
temp1 = [ToBeAssign_list; ind]';
temp2 = sortrows(temp1,2);
ToBeAssigned_list = temp2(:,1);
ToBeAssigned_AP = temp2(1,1);
end