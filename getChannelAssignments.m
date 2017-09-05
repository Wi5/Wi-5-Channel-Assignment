function [ CH_config ] = getChannelAssignments( pathloss_matrix, method_no )   
    %%%% check if the matrix is square and get the number of APs
    size_of_matrix = size(pathloss_matrix);
    
    number_of_APs = 0;
    if(size_of_matrix(1,1) == size_of_matrix(1,2))
        number_of_APs = size_of_matrix(1,1);
    else
        return;
    end
      
    %%%% initialize the working parameters
    initParameters;
    
    parameters.nAPs_actual=number_of_APs; %%%% number of APs
    parameters.nSSID_per_AP=1;  %%%% always 1, not used yet
    parameters.nAPs=parameters.nAPs_actual*parameters.nSSID_per_AP;
    parameters.chAssignmentMethod = chAssignmentMethods{method_no};

    %%%% import the path loss table from given source if any (e.g. from Pia's file)
    parameters.APlayout = APlayout{2}; %%% default is 1. change to 2 in the case of imported path loss
    parameters.importedAPpathLoss = pathloss_matrix; %This loads the path loss values measured by the AP's.

    %%%% create a central controller object
    cc=centralController(1, parameters);
   
    %%%% set the number of APs
    

    %%%% create the APs and update the list of APs in the controller
    for u_=1:parameters.nAPs
        %%% create the AP
        APs(u_)=accessPoint(u_, cc, parameters);

        %%%% assign the tx pwr level
        APs(u_).tx_pwr = parameters.APsInitTxPwr;

        %%%% update the AP list in the central controller
        cc.update_APs(APs);
    end

    %%%% run the channel assignment procedure which is a method in central
    %%%% controller
    cc.chAssignment(parameters);
    
    CH_config = [APs(:).CHn]; % Finds the channel conf. according to the LJMU's algorithm   
end

