% do lqr-lptv control design
try
    tic
    compsoc_lqr_based;
    toc
catch ME
    error_flag = 1;
    warning('LQR-LPTV ERROR!!!');
end

% TODO: working on this section!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% when there are no errors finding the controllers
if error_flag == 0
    
    % adjust feedback control matrices
    load (['output/results/exp' num2str(EXP) '/LQR_LPTV/ControlMatrices_set_1.mat']); % always load the same files
    load (['output/results/exp' num2str(EXP) '/LQR_LPTV/SysMatrices_set_1.mat']) % always load the same files
    
    clear K F;
    CL_PROD = eye(dim+1,dim+1); % closed-loop product
    for i = 1:length(Ks)
        K{i}  = -Ks{i};
        Cs{i} = C_aug{1};
        F{i}  = inv( Cs{i} / ( eye(dim+1) - As{i} - (Bs{i}*K{i}) ) * Bs{i}); % feedforward gain
        
        CL_PROD = CL_PROD * (As{i} + Bs{i}*K{i});
    end
    
    % stability check
    CL_POLES = eig(CL_PROD); 
    CL_POLES
    if max(max(abs(CL_POLES))) < 1 % if eigen values are less than 1 we know it is satble 
   
        % Do script-based simulation for the lqr-lptv controller
        [x, u, time] = multi_rate_script_based_simulation(PLOTS_SCRIPT_SIM_ON_OFF, SIM_TIME, SIM_REFERENCE, all_h, s{1}, sp_sequence_s, A_aug, B_aug, K, F);
    
        t_lqr_lptv_temp                     = time;
        step_info_lqr_lptv_temp             = stepinfo( x(1,1:length(t_lqr_lptv_temp)) );
    
        % check is there is an actual settling time: system is most likely stable
        if isnan(step_info_lqr_lptv_temp.SettlingTime) == 1
            step_info_lqr_lptv_samples(no_error_loop)   = Inf;
            step_info_lqr_lptv(no_error_loop)           = Inf;
        else
            step_info_lqr_lptv_samples(no_error_loop)   = ceil(step_info_lqr_lptv_temp.SettlingTime);
            step_info_lqr_lptv(no_error_loop)           = t_lqr_lptv_temp(step_info_lqr_lptv_samples(no_error_loop));
        end
    
        step_info_lqr_lptv
    
        % just save the best experiment        
        response_stability_percentage = 0.3;
        if (step_info_lqr_lptv(no_error_loop) == min(step_info_lqr_lptv)) && (step_info_lqr_lptv(no_error_loop) <= (SIM_TIME - SIM_TIME*response_stability_percentage))
            % SAVE DATA
            save(['output/results/exp' num2str(EXP) '/LQR_LPTV/SIM_RESULTS.mat'], ...
            'time','x','u','Ks','Ps','As','Bs','Qs','Rs', ...
            'PLOTS_SCRIPT_SIM_ON_OFF', 'SIM_TIME', 'SIM_REFERENCE', 'all_h', 's', 'sp_sequence_s', 'dim', ...
            'A_aug', 'B_aug', 'C_aug', 'K', 'F');
            %'time','x','u','Ks','Ps','As','Bs','Qs','Rs', ...
        end
        
        no_error_loop = no_error_loop + 1; % increment only when there were no errors in the solution
        
    end
       
end % end error flag