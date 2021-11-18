%% MAIN SETUP: SETS CONFIGURATIONS FOR BOTH PSO AND FT EXPERIMENTS

%% CLEAR: all workspace and global variables, and close all figues
clearvars -global; clearvars; close all; clc;

%% ADD CODES
addpath('timing');

%% SETUP
% COMMON SETUP: SETTINGS USED IN BOTH PSO AND FT FRAMEWORKS
controller_experiment = 1; % ex: 1-> (10ms,20ms,40ms), 2-> (30ms, 60ms, 120ms), 3-> (100ms, 200ms, 400ms)
variable_reference_enable = 1; % 1-> simulation is done with variable reference array 0-> simulation done with a fixed reference
run_statistics = 0; % 1-> run statistics: check responses and errors while varying the error probability 0 -> does not do that

% PSO SETUP: SETTINGS USED ONLY FOR THE PSO FRAMEWORK
controller_mode   = 3; % constant to change the controller design+simulation or just simulation
design_evaluation = 0; % 1 -> controller design + simulation, 0 -> simulation with already found controllers

% FT SETUP: SETTINGS USED ONLY FOR FT FRAMEWORK
% check_stability
% 1 -> controllers lyapunov stability check and simulation with quickest switching sequence
% 0 -> simulation with customized f but not lyapunov stability check: just to test controller functionality
check_stabilty = 0;

% mode_switching_enable
% 1 -> FT framework will vary the modes according to the error sequence input
% 0 -> FT framework won't use the error control input and will use the set controller_mode
mode_switching_enable = 1; 

%% LOAD TIMING SETTINGS: 
timing_parameters;

%% SIMULATION TIME
Tend = 10; % simulation time [s]

%% RUNNING FRAMEWORKS
mean_errors_array = [];

for ref_index = 1:3
    for pe_index = 0.1:0.05:0.9
        if run_statistics == 0
            % ERROR PROBABILITY
    %         pe = [.1 .1]; % fixed value
            pe = [pe_index pe_index]; % fixed value
            error_probability = pe;

            ref_magnitude = [1 10 100];
            ref_array = ref_magnitude(ref_index)*[0.01 0.02 0.03 0.04 0.05 0.04 0.03 0.02 0.01 0 -0.01 -0.02 -0.03 -0.04 -0.05 -0.04 -0.03 -0.02 -0.01 0]; % references that change in time [rad]: in case of switching experiments

            % CALLING FRAMEWORKS
            main_PSO;
            main_FT;

            % COMPARISONS: traces
            compare_pso_ft_traces;
            mean_errors_array = [mean_errors_array; ref_magnitude(ref_index)  unique(pe) mean_e1 mean_e2]
        else
            statistics;
            % COMPARISONS: statistics
            compare_statistics;    
        end

        close all;
    end
end


save mean_errors_results.mat mean_errors_array
  

%% 
figure;
semilogy(mean_errors_array(1:17,2), mean_errors_array(1:17,3), 'r*-'); hold on;
semilogy(mean_errors_array(18:34,2), mean_errors_array(18:34,3), 'rs-'); hold on;
semilogy(mean_errors_array(35:end,2), mean_errors_array(35:end,3), 'ro-'); hold on;

semilogy(mean_errors_array(1:17,2), mean_errors_array(1:17,4), 'b*-'); hold on;
semilogy(mean_errors_array(18:34,2), mean_errors_array(18:34,4), 'bs-'); hold on;
semilogy(mean_errors_array(35:end,2), mean_errors_array(35:end,4), 'bo-'); hold on;

xlabel('P_f');
ylabel('mean absolute error');
legend('\times 1 reference magnitude - FT', '\times 10 reference magnitude - FT', '\times 100 reference magnitude - FT', ...
       '\times 1 reference magnitude - BL', '\times 10 reference magnitude - BL', '\times 100 reference magnitude - BL');
grid on; grid minor;