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
design_evaluation = 1; % 1 -> controller design + simulation, 0 -> simulation with already found controllers

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
if run_statistics == 0
    % ERROR PROBABILITY
    pe = [.3 .3]; % fixed value
    error_probability = pe;

    % reference values: [rad]
    ref_array = [0.01 0.02 0.03 0.04 0.05 ...
                0.04 0.03 0.02 0.01 0 ...
                -0.01 -0.02 -0.03 -0.04 -0.05 ...
                -0.04 -0.03 -0.02 -0.01 0]; % sequence test with CompSOC
             
    
    % CALLING FRAMEWORKS
    main_PSO;
    main_FT;

    % COMPARISONS: traces
    compare_pso_ft_traces;
else
    statistics;
    % COMPARISONS: statistics
    compare_statistics;    
end

% close all




  