classdef accessPoint < handle
    properties
        ID
        location
        CHn
        freq
        tx_pwr
        AtchdSTAs=[];
        perSTA_txPwr
    end
    
    methods
        
        function obj = accessPoint(u_, cc, parameters, varargin)
            obj.ID = u_;
            if isempty(varargin)
                locate_AP(obj, cc, parameters);
            else
                obj.location = [0 0];
            end
            obj.CHn = randi(11);
            obj.freq  = parameters.freq(obj.CHn);
            obj.tx_pwr = parameters.APsInitTxPwr;
        end
        
        function locate_AP(obj, cc, parameters)
            x_temp=randi(parameters.area_X);
            y_temp=randi(parameters.area_Y);
            if isfield(cc.entities,'APs') %%% need to be checked later
                for ap=1:length(cc.entities.APs)
                    x_APs(ap)=cc.entities.APs(ap).location(1,1);
                    y_APs(ap)=cc.entities.APs(ap).location(1,2);
                end
                ii=0;
                while(min(sqrt((x_APs-x_temp).^2 + (y_APs-y_temp).^2))...
                        < parameters.APs_minDist)
                    x_temp=randi(parameters.area_X);
                    y_temp=randi(parameters.area_Y);
                    if ii+1 > 200
                        error('the ''parameters.area'' may need to be increased')
                    end
                end
            end
            obj.location=[x_temp, y_temp];
        end
        
        function set_CH(obj, parameters, n)
            obj.CHn=n;
            obj.freq  = parameters.freq(obj.CHn);
        end
    end
end