function [selected_AP, Rb, adjusted_Tx_pwr] = AP_selection_func(STA, AP_list_in, APs, STAs, parameters)

STA_ID = STA.ID;

if strcmp(parameters.AP_selection_method,'RSS_based')
    [RSS, ~, ~, ~] = getPwrPara(STA.location, APs, parameters);
    temp = [AP_list_in', RSS(AP_list_in)];
    temp = sortrows(temp,-2);
    temp(temp(:,2)<0.5*(temp(1,2)),:)=[];
    AP_list = temp(:,1)';
    
    if strcmp(parameters.pwrCtrl,'no')
        selected_AP = AP_list(1);
        [Rb_STA, Rb_prev] = available_bitrate(selected_AP, STA_ID, APs, STAs, parameters);
        Rb = [Rb_prev, Rb_STA];
        adjusted_Tx_pwr = APs(selected_AP).tx_pwr;
    elseif strcmp(parameters.pwrCtrl,'yes')
        for ii =1:length(AP_list)
            ap = AP_list(ii);
            [Rb_STA(ii), Rb_prev{ii}, tx_pwr(ii)] = pwrCtrl_func(ap, STA_ID, APs, STAs, parameters); %#ok<*AGROW>
            Rb_temp = Rb_prev{ii};
            %%% check if the change of the served rate for prev users are
            %%% not too harsh!
            if ~isempty(Rb_temp)
                mu(ii) = mean(([STAs(APs(ap).AtchdSTAs).reqRate] - Rb_temp)./[STAs(APs(ap).AtchdSTAs).reqRate]);
                if mu(ii) > parameters.max_change_of_rate
                    mu(ii) = -1e12;
                else
                    mu(ii) = abs(mu(ii));
                end
            else
                mu(ii) = 0;
            end
        end
        [~, ind] = max(Rb_STA./mu);
        if mu(ind) < 0
            selected_AP = -1; %%% a command for blocking the user
            Rb = 0;
            adjusted_Tx_pwr = 0;
        else
            selected_AP = AP_list(ind);
            Rb = [Rb_prev{ind}, Rb_STA(ind)];
            adjusted_Tx_pwr = tx_pwr(ind);
        end
    end
end
end