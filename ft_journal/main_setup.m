%% MAIN SETUP: SETS CONFIGURATIONS FOR BOTH PSO AND FT EXPERIMENTS
%% CLEAR: all workspace and global variables, and close all figues
clearvars -global; clearvars; close all; clc;

%% ADD CODES
addpath('timing');

%% SETUP
controller_experiment       = 1; % ex: 1-> (10ms,20ms,40ms), 2-> (30ms, 60ms, 120ms), 3-> (100ms, 200ms, 400ms)
run_statistics              = 0; % 1-> run statistics: check responses and errors while varying the error probability 0 -> does not do that

% SW SYS. -----------------------------------------------------------------
mode_switching_enable       = 1; % 1 -> vary modes according to the fault/error input sequence. 
                                 % 0 -> do not vary modes

% FOR BOTH SW AND FIXED SYS. ----------------------------------------------
control_modes               = 2; % 3 modes C1-C2-C3
ref_enable                  = 1; % 1 -> enables variable reference 0 -> gives a fixed reference: BOTH SW AND FIXED SYS.
controller_mode             = 1; % [1,2, or 3]: this is used for both SW and FIXED SYS. 
                                 % SW SYS.: when mode_switching_enable = 0 -> m = controller_mode
                                 % FIXED SYS.: always m = controller_mode
% Tend                        = 5; % simulation time [s]

ref_array                   = [-10 -20 -30 -40 -50 0 10 20 30 40 50]; % stronger refenrece changes



% DESIGN ------------------------------------------------------------------
check_stabilty              = 0; % 1 -> cntrl. Lyapunov stability check + simu. with quickest fsw. | 0 -> sim. with custom fsw (NO stability check)
evaluate_fsw                = 1; % evaluate working sequences (f_sw)
evaluate_pf                 = 1; % evaluate pf within a range (0,1) 

plots_modes                 = 0; % plots on/off for each mode
plots_ft_sim                = 0; % plots on/off for fault-tolerant simulation


                           
%% RUNNING FT FRAMEWORK: FAULT-TOLERANCE
% SWITCHING SYSTEMS SETUP
switching_systems_setup;


% LYAPUNOV VARIABLE AND SWITCHING CONFIGURATION ARRAY TO EXPLORE POSSIBLE SWITCHING SCENARIOS
% check feasible switching sequences that maintain the system stable: output working_sequences
if check_stabilty == 1
    % maximum number of times in a controller: max. values of fsw
    max_number_sw = 3; 
    % lyapunov stability check
    lyapunov_stability_pso_controllers;
    % saving working sequence
    save(['results/feasible_f_sw_sequences_n_' num2str(control_modes) '.mat'], 'working_sequences');
end




% EVALUATING SEQUENCES AND PF
if evaluate_pf == 0
    pf                  = [.4 .4]; % fixed value when pf is not varied
    error_probability   = pf;
end

if evaluate_fsw == 1
    load (['results/feasible_f_sw_sequences_n_' num2str(control_modes) '.mat']); % loading sequences found in stabilit check
    
    temp_sequences = [working_sequences(1,:); working_sequences(end,:)];
    
    for fsw_index = 1:2 % 2 = 2 working sequences: first and last
        if evaluate_pf == 1
            for pf_index = 0.1:0.1:0.6              
                % ERROR PROBABILITY                
                pf                  = [pf_index pf_index]; % fixed value
                error_probability   = pf;        
                % select f
                f = temp_sequences( fsw_index, : );
                
                % Show every loop pf and fsw                
                table(error_probability, control_modes)
                f_tran = f';
                S_tran = S';
                delays_tran = delays';
                table(f_tran, S_tran, delays_tran)
                
                % CALL FT FRAMWEORK
                main_FT;
                % COMPARISONS: traces
                compare_pso_ft_traces;
            end
        else
            % select f
            f = temp_sequences( fsw_index, : );
            % CALL FT FRAMWEORK
            main_FT;
            % COMPARISONS: traces
            compare_pso_ft_traces;            
        end
    end
else
    f = [1 1 2]; %  evaluate customized sequence
    % CALL FT FRAMWEORK
    main_FT;
    % COMPARISONS: traces
    compare_pso_ft_traces;
end



%% STATISTICS
if run_statistics == 1
    statistics;
    compare_statistics;
end

