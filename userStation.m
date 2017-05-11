classdef userStation < handle
    properties
        ID
        location
        reqRate
        CHn
        freq
        tx_pwr
        APs
        selected_AP
        servedRate
        trig
        blocked = 0;
    end
    
    methods
        function obj = userStation(u_, cc, parameters, varargin)
            obj.ID = u_;
            locate_STA(obj, cc, parameters);
            obj.reqRate=parameters.rates(randi(length(parameters.rates)));
            obj.CHn = randi(11);
            obj.freq  = parameters.freq(obj.CHn);
            obj.tx_pwr = parameters.STAsInitTxPwr;
        end
        
        function locate_STA(obj, cc, parameters)
            x_temp=randi(parameters.area_X);
            y_temp=randi(parameters.area_Y);
            x_STAs=[];
            y_STAs=[];
            if isfield(cc.entities,'APs')
                for ap=1:length(cc.entities.APs)
                    x_APs(ap)=cc.entities.APs(ap).location(1,1);
                    y_APs(ap)=cc.entities.APs(ap).location(1,2);
                end
                if isfield(cc.entities,'STAs')
                    for sta=1:length(cc.entities.STAs)
                        x_STAs(sta)=cc.entities.STAs(sta).location(1,1);
                        y_STAs(sta)=cc.entities.STAs(sta).location(1,2);
                    end
                end
                x_APs_STAs=[x_APs, x_STAs];
                y_APs_STAs=[y_APs, y_STAs];
                
                ii=0;
                while(min(sqrt((x_APs_STAs-x_temp).^2 ...
                        + (y_APs_STAs-y_temp).^2)) < parameters.STAs_minDist)
                    
                    x_temp=randi(parameters.area_X);
                    y_temp=randi(parameters.area_Y);
                    if ii+1 > 200
                        error('the ''parameters.area'' may need to be increased')
                    end
                end
            end
            obj.location=[x_temp, y_temp];
        end
        
        function update_APs(obj, APs)
            for ap=1:length(APs)
                obj.APs(ap)=APs(ap);
            end
        end
        
    end
end