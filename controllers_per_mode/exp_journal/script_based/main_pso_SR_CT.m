%% Single-Rate PSO for continuous time

step_info_sr_pso_samples = [];
step_info_sr_pso = [];

for PSO_index = 1:MAX_PSO_LOOP
    
    % controller parameters
    Ts      = 1e-6; % plant sampling period for CT simulation
    delay   = application_delay;
    Sat_u   = [1.5 -1.5]; % saturation for controller output [maximum minimum]
    Tend    = SIM_TIME; % simulation time [s]
    
    % execution
    main_pso_no_delay;
    
    % load Feedback control gain
    load (['output/results/SR_CT_controller/C-' num2str(PSO_index) '.mat']);
    
    % Simulation
    time_vector      = 0:(Ts*1000):SIM_TIME;
    reference_vector = ones(size(time_vector));
    x0 = [0;0;0;0]; % initial state 0
    
    Ac_plant = Ac;
    Bc_plant = Bc;
    Cc_plant = [1 0 0 0]; % for control purposes
    Dc_plant = 0; % for control purposes
    
    %sys_CL_NF = ss(Ac+Bc*K,Bc,Cc,Dc); % CL: without feedfordward control
    sys_CL_WF = ss(Ac_plant+Bc_plant*K,Bc_plant*F,Cc_plant,Dc_plant); % CL: with feedfordward control
    [y,t,~] = lsim(sys_CL_WF,reference_vector,time_vector,x0); % linear simulation CT
    
%     St_info = stepinfo(y);
%     St = t(floor(St_info.SettlingTime));
%     
    
    t_sr_pso_temp                       = t;
    step_info_sr_pso_temp               = stepinfo(y);
    
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
        time = t;
        x    = y;
        
        save(['output/results/SR_CT_controller/C-BEST.mat'],'K','F','Ts','Q','R');
        save(['output/results/SR_CT_controller/PSO_SIM_RESULTS.mat'],'time','x','step_info_sr_pso');
    end    
   
end