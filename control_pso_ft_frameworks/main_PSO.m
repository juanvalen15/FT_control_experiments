%% CLEAR: all workspace and global variables, and close all figues
% clearvars -global; clearvars; close all; clc;

%% LOAD NECESSARY CODE
addpath('pso_tools');
addpath('plant');
addpath('timing');
addpath('controllers');
addpath('simulink');
addpath('results');

%% USER INPUT
% controller_mode       = 1; % constant to change the controller design+simulation or just simulation
% design_evaluation     = 1; % 1 -> controller design + simulation, 0 -> simulation with already found controllers
% controller_experiment = 1; % ex: 1-> (10ms,20ms,40ms), 2-> (30ms, 60ms, 120ms), 3-> (100ms, 200ms, 400ms)

%% LOAD TIMING SETTINGS: 
timing_parameters;

%% USER CONTROL CONTROLLER MODE, CONTROLLER_EXPERIMENT, DESIGN/SIMULATION, AND TIMING PARAMETERS SELECTION:
Ts      = S(controller_mode);
delay   = delays(controller_mode);

% Ts      = S(1);
% delay   = delays(1);

%% LOAD PLANT MODEL: state-space space representation of CT
plant_model;

%% CT state-space representation of plant
sysc =ss(Ac_plant, Bc_plant, Cc_plant, Dc_plant);

%% D state-space representation of plant @ hp
sysd = c2d(sysc, hp, 'zoh'); 

%% PSO ALGORITHM INITIALIZATION AND EXECUTION
pso_execution;

%% Setting up reference
ref                 = 1;  % reference 1 [rad]: in case of no switching experiments
ref_array_sampling  = 20 * S(end); % WARNING: CONSTANT TO MULTIPLY WORST SAMPLING IN ORDER TO GIVE ENOUGH SETTLING TIME
ref_sampling_factor = ref_array_sampling / Sm;

%% PLOTTING RESULTS
plotting_steps_pso;
