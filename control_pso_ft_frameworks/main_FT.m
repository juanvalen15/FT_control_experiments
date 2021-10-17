%% CLEAR: all workspace and global variables, and close all figues
% clearvars -global; clearvars; close all; clc;

%% LOAD NECESSARY CODE
addpath('ft_tools');
addpath('plant');
addpath('timing');
addpath('controllers');
addpath('simulink');
addpath('results');

%% USER INPUT
% % 1 -> controllers lyapunov stability check and simulation with quickest switching sequence
% % 0 -> simulation with customized f but not lyapunov stability check: just to test controller functionality
% check_stabilty        = 0; 
% controller_experiment = 1; % ex: 1-> (10ms,20ms,40ms), 2-> (30ms, 60ms, 120ms), 3-> (100ms, 200ms, 400ms)

%% LOAD PLANT MODEL: state-space space representation of CT
plant_model;

%% CT state-space representation of plant for controller design using sample data model
C = [1 0 0 0];
D = 0;
sysc =ss(Ac_plant, Bc_plant, C, D);
dim = length(Ac_plant); % continuos time system state-space dimension

%% LOAD TIMING SETTINGS: 
timing_parameters;

%% PLANT DISCRETIZATION AND AUGMENTATION
plant_discretization_augmentation;

%% CONTROLLER GAINS
controller_gains;

%% SUBSYSTEMS FROM PSO DESIGNS
S1 = A_aug{1} + B_aug{1}*K1;
S2 = A_aug{2} + B_aug{2}*K2;
S3 = A_aug{3} + B_aug{3}*K3;

%% LYAPUNOV VARIABLE AND SWITCHING CONFIGURATION ARRAY TO EXPLORE POSSIBLE SWITCHING SCENARIOS
P = sdpvar(dim+1, dim+1, 'symmetric'); 
max_number_sw = 4; % maximum number of times in a controller

% check feasible switching sequences that maintain the system stable: output working_sequences
if check_stabilty == 1
    % lyapunov stability check
    lyapunov_stability_pso_controllers;
    % switching sequence allowed
    f = working_sequences(1,:); % chosen sequence: quickest
else
    f = [1 1 3]; % customized sequence
end


%% TO SIMULIK: WARNING
n                   = 3;  % three control modes
Sat_u               = single([1.5 -1.5]); % saturation for controller output [maximum minimum] [V]

ref                 = 1;  % reference 1 [rad]: in case of no switching experiments
ref_array_sampling  = 20 * S(end); % WARNING: CONSTANT TO MULTIPLY WORST SAMPLING IN ORDER TO GIVE ENOUGH SETTLING TIME
ref_sampling_factor = ref_array_sampling / Sm;

plant_discretization_at_hp_HIL;

%% adding delay for correct actuation in simulink
actuation_delay = delays(1)-Sm; % remaining time to simulate delay in simulink (execution time during the last slot of execution)

%% DISCRETE DELAY
delay_length = round(actuation_delay/hp);

%% PLOTTING RESULTS
% Tend = 40; % simulation time [s]
fprintf('\nDefined simulation time is: %d \n', Tend) % shows expected settling time
plotting_steps_ft;
