%%%% clear the workspace
clc
clear all
close all

%%%% initialize the working parameters
initParameters

%%%% import the path loss table from given source if any (e.g. from Pia's file)
parameters.APlayout = APlayout{1}; %%% default is 1. change to 2 in the case of imported path loss
if strcmp(parameters.APlayout,'imported')
    importedAPpathLoss_Pia %%%% this is loading the table named parameters.importedAPpathLoss
end

%%%% create a central controller object
cc=centralController(1, parameters);

%%%% define the set of initial AP tx powers
temp=parameters.APsInitTxPwr; %%% here we have chosen just the default value from initialized parameters

%%%% create the APs and update the list of APs in the controller
for u_=1:parameters.nAPs
    %%% create the AP
    APs(u_)=accessPoint(u_, cc, parameters);
    
    %%%% assign the tx pwr level
    APs(u_).tx_pwr = temp(randi(length(temp)));
    
    %%%% update the AP list in the central controller
    cc.update_APs(APs)
end

%%%% run the channel assignment procedure which is a method in central
%%%% controller
cc.chAssignment(parameters)

%%%%%%%%%%% end of the channel assignment procedure %%%%%%%%%%%%%



%%%% create the STAs and update the list of STAs in the controller
for u_=1:parameters.nSTAs
    %%% create the STA
    STAs(u_)=userStation(u_, cc, parameters);
    %%%% update the STAs list in the central controller
    cc.update_STAs(STAs)
end

%%%% now we can associate STAs with APs
for u_=1:parameters.nSTAs
    %%%% arguments: the STA and the list of the APs which are considered for its association  
    cc.AP_association(STAs(u_), 1:length(APs), parameters)
    %%%% update the STAs list in the central controller    
    cc.update_STAs(STAs)
end


%%%%%%%%%%% end of the STA-AP association %%%%%%%%%%%%%




%%%%%%%%%%% let's plot some results %%%%%%%%%%%%%

%%%% the assigned channel for each AP (e.g. AP(i)) can be found under APs(i).CHn
%%% as an example for plotting the histogram of assigned channel we can do:
CH_list_(:,1) = [APs(:).CHn];

%%%% we can further repeat the the channel assignment procedure for another
%%%% algorithm e.g. random channel assignemnt which is chAssignmentMethods{2}
parameters.chAssignmentMethod=chAssignmentMethods{2};
cc.chAssignment(parameters)
CH_list_(:,2) = [APs(:).CHn];

%%%% and the channel assignment for LCC which is chAssignmentMethods{3}
parameters.chAssignmentMethod=chAssignmentMethods{3};
cc.chAssignment(parameters)
CH_list_(:,3) = [APs(:).CHn];

%%%% variable CH_list_ has the assigned channels of SDN_based, random and LCC
%%%% let's plot their histogram all in one figure
figure
hist(CH_list_,1:11)
legend('SDN_{based}','unCoord','LCC')
xlabel('Ch Number')
ylabel('Number of times used')



%%%% we can also plot the network and show which AP each STA is associated
%%%% with.
clr={'dr','k','y','m','y','ob','.k','.y','.m','.y','sg','ko'};
figure
hold all

for ii = 1: length(APs)
    %%%% plot the APs locations, each channel has a color
    plot(APs(ii).location(1),APs(ii).location(2),char(clr(APs(ii).CHn)))
    %%%% plot the STAs associated with that AP with the same color
    for jj = 1: length(APs(ii).AtchdSTAs)        
          sta = APs(ii).AtchdSTAs(jj);
        plot(STAs(sta).location(1),STAs(sta).location(2),char(clr(STAs(sta).CHn)))
    end
end
xlabel('X')
ylabel('Y')
title('APs and STAs locations colored by their CH')