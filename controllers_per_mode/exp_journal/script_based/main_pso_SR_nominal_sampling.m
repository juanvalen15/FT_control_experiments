% Single-Rate PSO for nominal sampling period

step_info_sr_pso_samples = [];
step_info_sr_pso = [];

for PSO_index = 1:MAX_PSO_LOOP
    
    % controller parameters
    Sat_u   = [1.5 -1.5]; % saturation for controller output [maximum minimum]
    Tend    = SIM_TIME; % simulation time [s]
    
    % execution
    main_pso;
    
    % load Feedback control gain
    clear K_temp F_temp;
    load (['output/controllers/C-' num2str(PSO_index) '.mat']);
    K_temp{1} = double(K) % double to avoid error in lmi
    F_temp{1} = double(F) % double to avoid error in lmi
    
    % Do script-based simulation for the single-rate pso controller
    DELAY_ON_OFF = 1;
    [x, u, time] = single_rate_script_based_simulation(PLOTS_SCRIPT_SIM_ON_OFF, DELAY_ON_OFF, SIM_TIME, SIM_REFERENCE, Ts, A_aug{1}, B_aug{1}, K_temp, F_temp);
    
    t_sr_pso_temp                       = time;
    step_info_sr_pso_temp               = stepinfo( x(1,1:length(t_sr_pso_temp)) );
    
    % check is there is an actual settling time: system is most likely stable
    if isnan(step_info_sr_pso_temp.SettlingTime) == 1
        step_info_sr_pso_samples(PSO_index) = Inf;
        step_info_sr_pso(PSO_index)         = Inf;
    else
        step_info_sr_pso_samples(PSO_index) = ceil(step_info_sr_pso_temp.SettlingTime);
        step_info_sr_pso(PSO_index)         = t_sr_pso_temp(step_info_sr_pso_samples(PSO_index));
    end
    
    step_info_sr_pso
    
    % just save the best experiment
    if step_info_sr_pso(PSO_index) == min(step_info_sr_pso)
        t_best = time;
        x_best = x;
        u_best = u;
        
        K_best = K_temp;
        F_best = F_temp;
        save(['output/controllers/C-BEST-MODE-' num2str(mode_selection) '.mat'],'K','F','Ts','delay','Q','R','K_best','F_best');
        save(['output/controllers/PSO-SIM-RESULTS-MODE-' num2str(mode_selection) '.mat'],'time','x','u','step_info_sr_pso');
    end
end