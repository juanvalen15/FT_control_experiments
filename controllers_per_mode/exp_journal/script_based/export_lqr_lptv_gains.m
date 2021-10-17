% export to lqr-lptv control gains K and F to CompSOC C code

% Export: K and F
varK = [];
varF = [];
delete export_2_compsoc.txt
for i = 1:length(K)
    varK{i} = CompSoc(K{i},16);
    varF{i} = CompSoc(F{i},16);
    dlmwrite('export_2_compsoc.txt', ['float K' int2str(i) '[1][N] =' varK{i}, ...
                                      'float F' int2str(i) '[1][1] =' varF{i}],'-append', 'delimiter','');
end


% % EXPERIMENT 1
% for i = 1:290
%     if ( i == 29 || i==58 || i==87 || i==116 || i==145 || i==174 || i==203 || i==232 || i==261 || i==290 )
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){multiply_matrix(1, N, N, 1, K' int2str(i) ', augmented_state, new_control_inputA); multiply_matrix(1, 1, 1, 1, F' int2str(i) ', r, new_control_inputB);H_PATTERN = H2;}'], ...
%         '-append', 'delimiter','');
%     else
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){multiply_matrix(1, N, N, 1, K' int2str(i) ', augmented_state, new_control_inputA); multiply_matrix(1, 1, 1, 1, F' int2str(i) ', r, new_control_inputB);H_PATTERN = H1;}'], ...
%         '-append', 'delimiter','');
%     end
% end


% % EXPERIMENT 2
% for i = 1:145  
%     if ( i == 29 || i==58 || i==87 || i==116 || i==145 )
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){multiply_matrix(1, N, N, 1, K' int2str(i) ', augmented_state, new_control_inputA); multiply_matrix(1, 1, 1, 1, F' int2str(i) ', r, new_control_inputB);H_PATTERN = H2;}'], ...
%         '-append', 'delimiter','');
%     else
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){multiply_matrix(1, N, N, 1, K' int2str(i) ', augmented_state, new_control_inputA); multiply_matrix(1, 1, 1, 1, F' int2str(i) ', r, new_control_inputB);H_PATTERN = H1;}'], ...
%         '-append', 'delimiter','');
%     end
% end

% % EXPERIMENT 3
% for i = 1:58
%     if ( i == 29 || i==58 )
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){multiply_matrix(1, N, N, 1, K' int2str(i) ', augmented_state, new_control_inputA); multiply_matrix(1, 1, 1, 1, F' int2str(i) ', r, new_control_inputB);H_PATTERN = H2;}'], ...
%         '-append', 'delimiter','');
%     else
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){multiply_matrix(1, N, N, 1, K' int2str(i) ', augmented_state, new_control_inputA); multiply_matrix(1, 1, 1, 1, F' int2str(i) ', r, new_control_inputB);H_PATTERN = H1;}'], ...
%         '-append', 'delimiter','');
%     end
% end

% EXPERIMENT 4
for i = 1:29
    if ( i == 29 )
        dlmwrite('export_2_compsoc.txt', ...
        ['if ( k == ' int2str(i-1) ' ){multiply_matrix(1, N, N, 1, K' int2str(i) ', augmented_state, new_control_inputA); multiply_matrix(1, 1, 1, 1, F' int2str(i) ', r, new_control_inputB);H_PATTERN = H2;}'], ...
        '-append', 'delimiter','');
    else
        dlmwrite('export_2_compsoc.txt', ...
        ['if ( k == ' int2str(i-1) ' ){multiply_matrix(1, N, N, 1, K' int2str(i) ', augmented_state, new_control_inputA); multiply_matrix(1, 1, 1, 1, F' int2str(i) ', r, new_control_inputB);H_PATTERN = H1;}'], ...
        '-append', 'delimiter','');
    end
end

% for i = 1:29
%     if ( i == 29 )
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){int k_index = 0;for( k_index = 0; k_index < N; k_index++ ){temp_k[0][0] = K' int2str(i) '[0][0]; temp_k[0][1] = K' int2str(i) '[0][1]; temp_k[0][2] = K' int2str(i) '[0][2]; temp_k[0][3] = K' int2str(i) '[0][3]; temp_k[0][4] = K' int2str(i) '[0][4];};mk_mon_debug_info_students( 0, *float_debugg_temp_var_0, *float_debugg_temp_var_1, *float_debugg_temp_var_2, *float_debugg_temp_var_3, *float_debugg_temp_var_4 );H_PATTERN = H2;}'], ...
%         '-append', 'delimiter','');
%     else
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){int k_index = 0;for( k_index = 0; k_index < N; k_index++ ){temp_k[0][0] = K' int2str(i) '[0][0]; temp_k[0][1] = K' int2str(i) '[0][1]; temp_k[0][2] = K' int2str(i) '[0][2]; temp_k[0][3] = K' int2str(i) '[0][3]; temp_k[0][4] = K' int2str(i) '[0][4];};mk_mon_debug_info_students( 0, *float_debugg_temp_var_0, *float_debugg_temp_var_1, *float_debugg_temp_var_2, *float_debugg_temp_var_3, *float_debugg_temp_var_4 );H_PATTERN = H1;}'], ...
%         '-append', 'delimiter','');
%     end
% end
% 
% 
% for i = 1:length(K)    
%     if ( i == 29 )
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){temp_k[0][0] = F' int2str(i) '[0][0];mk_mon_debug_info_students( 0, 0, 0, 0, 0, *float_debugg_temp_var_0 );H_PATTERN = H2;}'], ...
%         '-append', 'delimiter','');
%     else
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){temp_k[0][0] = F' int2str(i) '[0][0];mk_mon_debug_info_students( 0, 0, 0, 0, 0, *float_debugg_temp_var_0 );H_PATTERN = H1;}'], ...
%         '-append', 'delimiter','');
%     end
% end



% for i = 1:length(K)    
%     if ( i == 29 || i==58 || i==87 || i==116 || i==145 )
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){int k_index = 0;for( k_index = 0; k_index < N; k_index++ ){temp_k[0][0] = K' int2str(i) '[0][0]; temp_k[0][1] = K' int2str(i) '[0][1]; temp_k[0][2] = K' int2str(i) '[0][2]; temp_k[0][3] = K' int2str(i) '[0][3]; temp_k[0][4] = K' int2str(i) '[0][4];};mk_mon_debug_info_students( 0, *float_debugg_temp_constant_k_0, *float_debugg_temp_constant_k_1, *float_debugg_temp_constant_k_2, *float_debugg_temp_constant_k_3, *float_debugg_temp_constant_k_4 );H_PATTERN = H2;}'], ...
%         '-append', 'delimiter','');
%     else
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){int k_index = 0;for( k_index = 0; k_index < N; k_index++ ){temp_k[0][0] = K' int2str(i) '[0][0]; temp_k[0][1] = K' int2str(i) '[0][1]; temp_k[0][2] = K' int2str(i) '[0][2]; temp_k[0][3] = K' int2str(i) '[0][3]; temp_k[0][4] = K' int2str(i) '[0][4];};mk_mon_debug_info_students( 0, *float_debugg_temp_constant_k_0, *float_debugg_temp_constant_k_1, *float_debugg_temp_constant_k_2, *float_debugg_temp_constant_k_3, *float_debugg_temp_constant_k_4 );H_PATTERN = H1;}'], ...
%         '-append', 'delimiter','');
%     end
% end


% for i = 1:length(K)    
%     if ( i == 29 || i==58 || i==87 || i==116 || i==145 )
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){temp_k[0][0] = F' int2str(i) '[0][0];mk_mon_debug_info_students( 0, 0, 0, 0, 0, *float_debugg_temp_constant_k_0 );H_PATTERN = H2;}'], ...
%         '-append', 'delimiter','');
%     else
%         dlmwrite('export_2_compsoc.txt', ...
%         ['else if ( k == ' int2str(i-1) ' ){temp_k[0][0] = F' int2str(i) '[0][0];mk_mon_debug_info_students( 0, 0, 0, 0, 0, *float_debugg_temp_constant_k_0 );H_PATTERN = H1;}'], ...
%         '-append', 'delimiter','');
%     end
% end
