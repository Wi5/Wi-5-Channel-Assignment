

%%%%%% 802.11g (ofdm), 13 channels + channel 14

%parameters.nCH=11  + 2 +  1;
%parameters.freq=[2.412e9  +  5e6*(0:12) 2.4840e+009];

%%%%%% 802.11g (ofdm), 11 channels
parameters.nCH=11;
parameters.freq=[2.412e9  +  5e6*(0:10)];
parameters.BW=20e6; %% MHz
parameters.maxRate=54e6; %%Mbps
parameters.OFDM_MDR = [0, 10^6, 2*10^6, 6*10^6, 9*10^6, 12*10^6, 18*10^6, 24*10^6, 36*10^6, 48*10^6, 54*10^6];
parameters.LossExp=2;

%%%%% representing the overlap between channels (rounded values, enough for this simulation)
parameters.I_coef = ...
    [0.65 0.8 0.6 0.4 0.2 0.0 0.0 0.0 0.0 0.0 0.0;...
     0.8 0.65 0.8 0.6 0.4 0.2 0.0 0.0 0.0 0.0 0.0;...
     0.6 0.8 0.65 0.8 0.6 0.4 0.2 0.0 0.0 0.0 0.0;...
     0.4 0.6 0.8 0.65 0.8 0.6 0.4 0.2 0.0 0.0 0.0;...
     0.2 0.4 0.6 0.8 0.65 0.8 0.6 0.4 0.2 0.0 0.0;...
     0.0 0.2 0.4 0.6 0.8 0.65 0.8 0.6 0.4 0.2 0.0;...
     0.0 0.0 0.2 0.4 0.6 0.8 0.65 0.8 0.6 0.4 0.2;...
     0.0 0.0 0.0 0.2 0.4 0.6 0.8 0.65 0.8 0.6 0.4;...
     0.0 0.0 0.0 0.0 0.2 0.4 0.6 0.8 0.65 0.8 0.6;...
     0.0 0.0 0.0 0.0 0.0 0.2 0.4 0.6 0.8 0.65 0.8;...
     0.0 0.0 0.0 0.0 0.0 0.0 0.2 0.4 0.6 0.8 0.65;...
     ]';
parameters.orthogCoef=sum(parameters.I_coef(1:length(parameters.I_coef),[1,6,11]).^2,2);


%%% defing the size of the area (Range of Interest)
parameters.ROI=300;   
parameters.area_X=parameters.ROI; %%% in meters
parameters.area_Y=parameters.ROI; %%% in meters

parameters.nAPs_actual=4; %%%% number of APs
parameters.nSSID_per_AP=1;  %%%% always 1, not used yet
parameters.nAPs=parameters.nAPs_actual*parameters.nSSID_per_AP;
parameters.APs_minDist=50; %%% in meters

graphThresh = -155; %%% a threshold to create graph table in dBm
parameters.graphThresh = 10^(graphThresh/10); %%% in mW

parameters.APpwrMin = 0;
parameters.APpwrMax = 40;
parameters.APsInitTxPwr=(parameters.APpwrMin + parameters.APpwrMax)/2; %%% AP default power in dBm

noise=-99; %%% front-end noise in dBm
parameters.noise=10^(noise/10);%%% in mW

parameters.nSTAs=200;
parameters.STAs_minDist=1; %%% in meters
parameters.STAs_APs_minDist=1;
parameters.vel_mps = 1;%%% meter per sec
parameters.STA_move = 'yes';
parameters.STAsInitTxPwr=parameters.APsInitTxPwr; %%% STA default power in dBm

rates_low=1e6*[0.1, 0.2, 0.4, 0.8, 1.6];
rates_med=1e6*[0.2, 0.4, 0.8, 2, 3];
rates_high=1e6*[0.5, 0.8, 1, 2, 4, 6];
rates_Ales = 1e6*[0.04 0.05 0.5 1 5];
parameters.rates=4*rates_Ales;
parameters.U_thresh=50; %% percent
parameters.rate_pwr_tolerance = 0.1; %%% pwr cntrl acts for more than 10% difference from required rate
parameters.max_change_of_rate = 0.3; %%% maximum acceptable change of rate in current users due to a new joining user (1.0 means bypass)

%%% define the AP selection method: (1) SINR-based (2) Fittingness-based by Alessandro
chAssignmentMethods={'SDN_based','unCoord','LCC','LCC_orthgCH','SDN_based_orthgCH'};
AP_selection_methods={'RSS_based','FF_based'};
pwrCtrl={'no','yes'};
blocking = {'no','yes'};
APlayout = {'distance_based', 'imported'}; %%% for the possibility of importing AP layout based on path loss instead of distance
parameters.AP_selection_method=AP_selection_methods{1}; %%% default
parameters.chAssignmentMethod=chAssignmentMethods{1}; %%% default
parameters.pwrCtrl=pwrCtrl{1}; %%% default
parameters.blocking = blocking{1}; %%% default
parameters.APlayout = APlayout{2}; %%% default is 1

