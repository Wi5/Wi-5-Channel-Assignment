classdef centralController < handle
    properties
        ID
        entities
    end
    
    methods
        
        function obj = centralController(u_, parameters, varargin)
            obj.ID = u_;
        end
        
        function update_APs(obj, APs)
            for ap=1:length(APs)
                obj.entities.APs(ap)=APs(ap);
            end
        end
        
        function update_STAs(obj, STAs)
            for ap=1:length(STAs)
                obj.entities.STAs(ap)=STAs(ap);
            end
        end
        
        function chAssignment(obj, parameters)
            chAssignmentFunc(obj.entities.APs, parameters)
        end
        
        function AP_association(obj, STA, AP_list, parameters)
            APs = obj.entities.APs;
            STAs = obj.entities.STAs;
            
            
            [selected_AP, Rb, adjusted_Tx_pwr] = AP_selection_func(STA, AP_list, APs, STAs, parameters);
            
            if selected_AP == -1
                STA.blocked = 1;
                STA.servedRate = 0;
            else
                STA.selected_AP=selected_AP;
                APs(selected_AP).AtchdSTAs=[APs(selected_AP).AtchdSTAs, STA.ID];
                
                STA.CHn=APs(selected_AP).CHn;
                STA.freq=APs(selected_AP).freq;
                nAtchdSTAs=length(APs(selected_AP).AtchdSTAs);
                for ss=1:nAtchdSTAs
                    STAs(APs(selected_AP).AtchdSTAs(ss)).servedRate = min(Rb(ss), STAs(APs(selected_AP).AtchdSTAs(ss)).reqRate);
                end
                APs(selected_AP).perSTA_txPwr(nAtchdSTAs)=adjusted_Tx_pwr;
                APs(selected_AP).tx_pwr = mean(APs(selected_AP).perSTA_txPwr);
            end
        end
        
        function [intf, SINR]=getSINR (obj, STA, parameters)
            APs = obj.entities.APs;
            selected_AP = STA.selected_AP;
            rcvPwr=zeros(1,length(APs));
            for ap1 = 1:length(APs)
                d = pdist2([APs(ap1).location], [STA.location]);
                rcvPwr(1,ap1) = 10.^(([APs(ap1).tx_pwr] - 10*log10((4*pi/3e8*[APs(ap1).freq].*d).^parameters.LossExp))/10);
                rcvPwr(1,ap1)=rcvPwr(1,ap1)*parameters.I_coef(APs(ap1).CHn,STA.CHn);
            end
            d = pdist2([APs(selected_AP).location], [STA.location]);
            ind=find(APs(selected_AP).AtchdSTAs == STA.ID);
            tx_pwr = APs(selected_AP).perSTA_txPwr(ind);
            rcvPwr(1,selected_AP) = 10.^((tx_pwr - 10*log10((4*pi/3e8*[APs(selected_AP).freq].*d).^parameters.LossExp))/10);
            rcvPwr(1,selected_AP)=rcvPwr(1,selected_AP)*parameters.I_coef(APs(selected_AP).CHn,STA.CHn);
            
            temp=rcvPwr;
            temp(selected_AP)=[];
            intf=sum(temp);
            SINR=10*log10(rcvPwr(selected_AP)/(parameters.noise+intf)); %%% dont involve graphThresh to get the real SINR
        end
    end
end