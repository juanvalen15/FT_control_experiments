%% MAIN SETUP: SETS CONFIGURATIONS FOR BOTH PSO AND FT EXPERIMENTS
%% CLEAR: all workspace and global variables, and close all figues
clearvars -global; clearvars; close all; clc;

%% ADD CODES
addpath('timing');

%% SETUP
controller_experiment       = 1; % ex: 1-> (10ms,20ms,40ms), 2-> (30ms, 60ms, 120ms), 3-> (100ms, 200ms, 400ms)
variable_reference_enable   = 1; % 1-> sim. with var. ref. | 0-> sim. with fixed ref.
mode_switching_enable       = 1; % 1 -> vary modes according to the fault/error input sequence. | 0 -> do not vary modes
run_statistics              = 0; % 1-> run statistics: check responses and errors while varying the error probability 0 -> does not do that

control_modes               = 3; % 3 modes C1-C2-C3
controller_mode             = 3; % [1,2, or 3]

find_controllers_per_mode   = 1; % to find K1-K2-K3 - F1-F2-F3
design_evaluation           = 1; % 1 -> ctrl. design + sim. | 0 -> sim. with existent ctrl.

check_stabilty              = 1; % 1 -> cntrl. Lyapunov stability check + simu. with quickest fsw. | 0 -> sim. with custom fsw (NO stability check)
evaluate_fsw                = 0; % evaluate working sequences (f_sw)
evaluate_pf                 = 0; % evaluate pf within a range (0,1) 

plots_modes                 = 0; % plots on/off for each mode
plots_ft_sim                = 1; % plots on/off for fault-tolerant simulation

Tend                        = 10; % simulation time [s]
ref_array                   = [0.1 0.2 0.3 0.4 0.5 ...
                               0.4 0.3 0.2 0.1 0 ...
                               -0.1 -0.2 -0.3 -0.4 -0.5 ...
                               -0.4 -0.3 -0.2 -0.1 0]; % reference_array: sequence test with CompSOC

%% LOAD TIMING SETTINGS:
timing_parameters;


%% RUNNING FRAMEWORKS: PSO FOR MODES C1-C2-C3
if find_controllers_per_mode == 1  
    main_PSO;
end


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
    save('results/feasible_f_sw_sequences.mat', 'working_sequences');
end




% EVALUATING SEQUENCES AND PF
if evaluate_pf == 0
    pf                  = [.3 .3]; % fixed value when pf is not varied
    error_probability   = pf;
end

if evaluate_fsw == 1
    load 'results/feasible_f_sw_sequences.mat'; % loading sequences found in stabilit check
    %for fsw_index = 1:length(working_sequences)
    for fsw_index = 1
        if evaluate_pf == 1
            %for pf_index = 0.1:0.1:0.9
            for pf_index = 0.01
                
                % ERROR PROBABILITY
                pf                  = [pf_index pf_index]; % fixed value
                error_probability   = pf;        
                % select f
                f = working_sequences(fsw_index,:);
                % CALL FT FRAMWEORK
                main_FT;
                % COMPARISONS: traces
                compare_pso_ft_traces;
            end
        else
            % select f
            f = working_sequences(fsw_index,:);
            % CALL FT FRAMWEORK
            main_FT;
            % COMPARISONS: traces
            compare_pso_ft_traces;            
        end
    end
else
    f = [1 1 3]; %  evaluate customized sequence
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

