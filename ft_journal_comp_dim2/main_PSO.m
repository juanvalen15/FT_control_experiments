%% CLEAR: all workspace and global variables, and close all figues
% clearvars -global; clearvars; close all; clc;

%% LOAD NECESSARY CODE
addpath('pso_tools');
addpath('plant');
addpath('timing');
addpath('controllers');
addpath('simulink');
addpath('results');

%% LOAD TIMING SETTINGS: 
timing_parameters;

%% LOOP TO DESIGN ALL THE n CONTROLLERS: K1 K2 K3 | F1 F2 F3

for controllers_index = 1:control_modes % only three controllers     
    % USER CONTROL CONTROLLER MODE, CONTROLLER_EXPERIMENT, DESIGN/SIMULATION, AND TIMING PARAMETERS SELECTION    
    Ts      = S(controllers_index);
    delay   = delays(controllers_index);    

    % LOAD PLANT MODEL: state-space space representation of CT
    plant_model;

    % CT state-space representation of plant
    sysc = ss(Ac_plant, Bc_plant, Cc_plant, Dc_plant);

    % D state-space representation of plant @ hp
    sysd = c2d(sysc, hp, 'zoh'); 
    
    % PSO ALGORITHM INITIALIZATION AND EXECUTION
    pso_execution;

    % Setting up reference
    ref                 = 1;  % reference 1 [rad]: in case of no switching experiments
    ref_array_sampling  = 20 * S(end); % WARNING: CONSTANT TO MULTIPLY WORST SAMPLING IN ORDER TO GIVE ENOUGH SETTLING TIME
    ref_sampling_factor = ref_array_sampling / Sm;

    % PLOTTING RESULTS
    plotting_steps_pso;
end