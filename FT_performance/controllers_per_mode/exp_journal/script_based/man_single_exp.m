%% CLEAR: all workspace and global variables, and close all figures
clearvars -global; clearvars; close all; clc;

% -------------------------------------------------------------------------
%% addpaths
% -------------------------------------------------------------------------
addpath('plant');
addpath('pa_tools');
addpath('timings');
addpath('output'); 
addpath('single_rate_tools');
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
%% script configuration
% -------------------------------------------------------------------------
Do_SINGLE_RATE_PSO_NOMINAL = 1; % single rate controller: PSO FOR NOMINAL SAMPLING PERIOD
Do_SINGLE_RATE_PSO         = 1; % single rate controller: PSO
Do_LMI_PSO                 = 1; % multi rate controller: LMI+PSO 
Do_FULLY_LMI               = 0; % multi rate controller: FULLY LMI 
Do_LQR_LPTV                = 0; % multi rate controller: LQR-LPTV
% -------------------------------------------------------------------------
SIM_TIME                = 2; % Simulation time in seconds [s]
SIM_REFERENCE           = 0.05; % reference 
% -------------------------------------------------------------------------
PLOTS_PSO_CORE_ON_OFF   = 0; % 1 = ON, 0 = OFF
PLOTS_SCRIPT_SIM_ON_OFF = 0; % 1 = ON, 0 = OFF
MAX_PSO_LOOP            = 10; % MAX_PSO_LOOP pso controllers: to find best out of those
% -------------------------------------------------------------------------


%% ------------------------------------------------------------------------
for EXP = 1:4 % EXP = number of experiments: this change the timing set
	% directories
    exp_directory           = ['output/results/exp' num2str(EXP)];
	mkdir(exp_directory);   %create the directory

    control_directory       = ['output/results/exp' num2str(EXP) '/SR_PSO_NOMINAL'];
	mkdir(control_directory);   %create the directory    
    
    control_directory       = ['output/results/exp' num2str(EXP) '/SR_PSO'];
	mkdir(control_directory);   %create the directory
    
    control_directory       = ['output/results/exp' num2str(EXP) '/LMI_PSO'];
	mkdir(control_directory);   %create the directory
    
	control_directory       = ['output/results/exp' num2str(EXP) '/FULLY_LMI'];
	mkdir(control_directory);   %create the directory    
    
    control_directory       = ['output/results/exp' num2str(EXP) '/LQR_LPTV'];
	mkdir(control_directory);   %create the directory
    
    
	
	%% Timing
	timings_set; % both lmi and lqr based

	%% Plant 
	plant; % plant
	plant_discretization; % discretization

	
	%% -----------------------------------------------------------------------------------
	% single rate controller design for the nominal sampling period
	% -----------------------------------------------------------------------------------
	if (Do_SINGLE_RATE_PSO_NOMINAL == 1) 	
        % store temporally --------------------------
        temp_Do_SINGLE_RATE_PSO = Do_SINGLE_RATE_PSO;
        temp_Do_LMI_PSO         = Do_LMI_PSO;
        temp_Do_FULLY_LMI       = Do_FULLY_LMI;
        temp_Do_LQR_LPTV        = Do_LQR_LPTV;
        % set to zero for this controller design ----
        Do_SINGLE_RATE_PSO = 0;
        Do_LMI_PSO = 0;
        Do_FULLY_LMI = 0;
        Do_LQR_LPTV = 0;
        % -------------------------------------------
        
        step_info_sr_pso_nominal_samples = [];
        step_info_sr_pso_nominal = [];
        
        for PSO_index = 1:MAX_PSO_LOOP        
            
            for SP_index = 1:length(SP(1))            
                % controller parameters 
                Ts      = SP(1);
                delay   = application_delay;
                Sat_u   = [1.5 -1.5]; % saturation for controller output [maximum minimum]  
                Tend    = 2; % simulation time [s]

                % execution

                main_pso;
            end

            % load Feedback control gain
            clear K_temp F_temp;
            for SP_index = 1:length(SP(1))            
                load (['output/results/exp' num2str(EXP) '/SR_PSO_NOMINAL/C' num2str(SP_index) '-' num2str(PSO_index) '.mat']);
                K_temp{SP_index} = K;
                F_temp{SP_index} = F;
            end

            % Do script-based simulation for the single-rate pso controller
            DELAY_ON_OFF = 1;
            [x, u, time] = single_rate_script_based_simulation(PLOTS_SCRIPT_SIM_ON_OFF, DELAY_ON_OFF, SIM_TIME, SIM_REFERENCE, SP(1), A_aug{1}, B_aug{1}, K_temp, F_temp);
                        
            t_sr_pso_nominal_temp                       = time;
            step_info_sr_pso_nominal_temp               = stepinfo( x(1,1:length(t_sr_pso_nominal_temp)) );          
            step_info_sr_pso_nominal_samples(PSO_index) = ceil(step_info_sr_pso_nominal_temp.SettlingTime);
            step_info_sr_pso_nominal(PSO_index)         = t_sr_pso_nominal_temp(step_info_sr_pso_nominal_samples(PSO_index));            
            
            
            % just save the best experiment
            if step_info_sr_pso_nominal(PSO_index) == min(step_info_sr_pso_nominal)
               t_best = time;
               x_best = x;  
               u_best = u;              
               save(['output/results/exp' num2str(EXP) '/SR_PSO_NOMINAL/C' num2str(SP_index) '-BEST.mat'],'K','F','Ts','delay','Q','R');        
            end
        end
		
		% SAVE DATA
        clear time x u;
        time = t_best;
        x    = x_best;
        u    = u_best;
 		save(['output/results/exp' num2str(EXP) '/SR_PSO_NOMINAL/SIM_RESULTS.mat'],'time','x','u','step_info_sr_pso_nominal');
        
        
        % set back to temp values -----------------------------------------
        Do_SINGLE_RATE_PSO = temp_Do_SINGLE_RATE_PSO;
        Do_LMI_PSO         = temp_Do_LMI_PSO;
        Do_FULLY_LMI       = temp_Do_FULLY_LMI;
        Do_LQR_LPTV        = temp_Do_LQR_LPTV;
        % -----------------------------------------------------------------
	end
	% -----------------------------------------------------------------------------------	    

    
    %% -----------------------------------------------------------------------------------
	% do single rate pso controller design, simulation and export controllers and results
	% -----------------------------------------------------------------------------------
	if (Do_SINGLE_RATE_PSO == 1) 	
        % store temporally --------------------------
        temp_Do_SINGLE_RATE_PSO_NOMINAL = Do_SINGLE_RATE_PSO_NOMINAL;
        temp_Do_LMI_PSO                 = Do_LMI_PSO;
        temp_Do_FULLY_LMI               = Do_FULLY_LMI;
        temp_Do_LQR_LPTV                = Do_LQR_LPTV;
        % set to zero for this controller design ----
        Do_SINGLE_RATE_PSO_NOMINAL = 0;
        Do_LMI_PSO = 0;
        Do_FULLY_LMI = 0;
        Do_LQR_LPTV = 0;
        % -------------------------------------------
        
        step_info_sr_pso_samples = [];
        step_info_sr_pso = [];
        
        for PSO_index = 1:MAX_PSO_LOOP        
            
            for SP_index = 1:length(SP_baseline)            
                % controller parameters 
                Ts      = SP_baseline;
                delay   = application_delay;
                Sat_u   = [1.5 -1.5]; % saturation for controller output [maximum minimum]  
                Tend    = 2; % simulation time [s]

                % execution

                main_pso;
            end

            % load Feedback control gain
            clear K_temp F_temp;
            for SP_index = 1:length(SP_baseline)
                load (['output/results/exp' num2str(EXP) '/SR_PSO/C' num2str(SP_index) '-' num2str(PSO_index) '.mat']);
                K_temp{SP_index} = K;
                F_temp{SP_index} = F;
            end

            % Do script-based simulation for the single-rate pso controller
            DELAY_ON_OFF = 1;
            [x, u, time] = single_rate_script_based_simulation(PLOTS_SCRIPT_SIM_ON_OFF, DELAY_ON_OFF, SIM_TIME, SIM_REFERENCE, SP_baseline, A_aug_baseline, B_aug_baseline, K_temp, F_temp);
                        
            t_sr_pso_temp                       = time;
            step_info_sr_pso_temp               = stepinfo( x(1,1:length(t_sr_pso_temp)) );          
            step_info_sr_pso_samples(PSO_index) = ceil(step_info_sr_pso_temp.SettlingTime);
            step_info_sr_pso(PSO_index)         = t_sr_pso_temp(step_info_sr_pso_samples(PSO_index));            
            
            
            % just save the best experiment
            if step_info_sr_pso(PSO_index) == min(step_info_sr_pso)
               t_best = time;
               x_best = x;  
               u_best = u;              
               save(['output/results/exp' num2str(EXP) '/SR_PSO/C' num2str(SP_index) '-BEST.mat'],'K','F','Ts','delay','Q','R');        
            end
        end
		
		% SAVE DATA
        clear time x u;
        time = t_best;
        x    = x_best;
        u    = u_best;
 		save(['output/results/exp' num2str(EXP) '/SR_PSO/SIM_RESULTS.mat'],'time','x','u','step_info_sr_pso');
        
        
        % set back to temp values -----------------------------------------
        Do_SINGLE_RATE_PSO_NOMINAL = temp_Do_SINGLE_RATE_PSO_NOMINAL;
        Do_LMI_PSO      = temp_Do_LMI_PSO;
        Do_FULLY_LMI    = temp_Do_FULLY_LMI;
        Do_LQR_LPTV     = temp_Do_LQR_LPTV;
        % -----------------------------------------------------------------
	end
	% -----------------------------------------------------------------------------------	
    
    
	%% -----------------------------------------------------------------------------------
	% do LMI+PSO controller design, simulation and export controllers and results
	% -----------------------------------------------------------------------------------
	if (Do_LMI_PSO == 1) 
        % store temporally --------------------------
        temp_Do_SINGLE_RATE_PSO         = Do_SINGLE_RATE_PSO;
        temp_Do_SINGLE_RATE_PSO_NOMINAL = Do_SINGLE_RATE_PSO_NOMINAL;
        temp_Do_FULLY_LMI               = Do_FULLY_LMI;
        temp_Do_LQR_LPTV                = Do_LQR_LPTV;
        % set to zero for this controller design ----
        Do_SINGLE_RATE_PSO = 0;
        Do_SINGLE_RATE_PSO_NOMINAL = 0;
        Do_FULLY_LMI = 0;
        Do_LQR_LPTV = 0;
        % -------------------------------------------        
        
        feasibility_loop = 1;
        feasibility_check_limit = 10; % MAX. THIS LIMIT TO LOOK FOR FEASIBLITY
        while( feasibility_loop <= feasibility_check_limit )    
                    
            step_info_sr_pso_samples = [];
            step_info_sr_pso = [];
            
            for PSO_index = 1:MAX_PSO_LOOP        
                
                for SP_index = 1:length(nominal_sampling_period)            
                    % controller parameters 
                    Ts      = nominal_sampling_period;
                    delay   = application_delay;
                    Sat_u   = [1.5 -1.5]; % saturation for controller output [maximum minimum]  
                    Tend    = 2; % simulation time [s]

                    % execution
                    main_pso;
                end

                % load Feedback control gain
                clear K_temp F_temp;
                for SP_index = 1:length(nominal_sampling_period)
                    load (['output/results/exp' num2str(EXP) '/LMI_PSO/C' num2str(SP_index) '-' num2str(PSO_index) '.mat']);
                    K_temp{SP_index} = double(K); % double to avoid error in lmi
                    F_temp{SP_index} = double(F); % double to avoid error in lmi
                end

                % Do script-based simulation for the single-rate pso controller
                DELAY_ON_OFF = 1;
                [x, u, time] = single_rate_script_based_simulation(PLOTS_SCRIPT_SIM_ON_OFF, DELAY_ON_OFF, SIM_TIME, SIM_REFERENCE, nominal_sampling_period, A_aug{1}, B_aug{1}, K_temp, F_temp);

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
                   save(['output/results/exp' num2str(EXP) '/LMI_PSO/C' num2str(SP_index) '-BEST.mat'],'K','F','Ts','delay','Q','R','K_best','F_best');        
                end
            
            end
            
            % SAVE DATA
            clear time x u;
            time = t_best;
            x    = x_best;
            u    = u_best;
            save(['output/results/exp' num2str(EXP) '/LMI_PSO/PSO_SIM_RESULTS.mat'],'time','x','u','step_info_sr_pso');            

            
            % pso stability exploration and find all switching gains
            clear K F;
            K{1} = K_best{1}; % just adjusting the variable used in pso stability exploration with lmis
            F{1} = F_best{1};
            LMI_PSO_FEASIBLE = 0; % flag before checking feasibility

            pso_stability_exploration;

            if LMI_PSO_FEASIBLE == 1
                break;                
            end                      
        end

        % if system is feasible then we do the simulation
        if LMI_PSO_FEASIBLE == 1
            % Do script-based simulation for the lmi+pso controller
            [x, u, time] = multi_rate_script_based_simulation(PLOTS_SCRIPT_SIM_ON_OFF, SIM_TIME, SIM_REFERENCE, all_h, s{1}, sp_sequence_s, A_aug, B_aug, K, F);

            % SAVE DATA
            save(['output/results/exp' num2str(EXP) '/LMI_PSO/SIM_RESULTS.mat'],'time','x','u');                        
        end
            
        LMI_PSO_FEASIBLE = 0; % reset feasibility flag
        
        % set back to temp values -----------------------------------------
        Do_SINGLE_RATE_PSO  = temp_Do_SINGLE_RATE_PSO;
        Do_SINGLE_RATE_PSO_NOMINAL = temp_Do_SINGLE_RATE_PSO_NOMINAL;
        Do_FULLY_LMI        = temp_Do_FULLY_LMI;
        Do_LQR_LPTV         = temp_Do_LQR_LPTV;
        % -----------------------------------------------------------------        
	end
	% -----------------------------------------------------------------------------------	    
    


end













%% REMOVE PATHS: in order to mantain the logic paths for other workspaces
rmpath('plant');
rmpath('pa_tools');
rmpath('timings');
rmpath('output');
rmpath('lptv_tools');
rmpath('pso_tools');
rmpath('pso_tools_no_delay');
rmpath('simulink');
rmpath('single_rate_tools');