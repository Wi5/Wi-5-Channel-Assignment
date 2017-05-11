function chAssignmentFunc(APs, parameters)

if isequal(parameters.chAssignmentMethod,'SDN_based')
    chAssign_opt(APs, parameters);

elseif isequal(parameters.chAssignmentMethod,'unCoord')
    chAssign_random(APs, parameters);

elseif isequal(parameters.chAssignmentMethod,'LCC')
    chAssign_LCC(APs, parameters);
       
elseif isequal(parameters.chAssignmentMethod,'LCC_orthgCH')
    chAssign_LCC_orthg(APs, parameters);

elseif isequal(parameters.chAssignmentMethod,'SDN_based_orthgCH')
    chAssign_opt_orthg(APs, parameters);
    
end

end