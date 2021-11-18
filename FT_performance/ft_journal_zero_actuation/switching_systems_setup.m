%% SWITCHING SYSTEM CONFIGURATION
% SETTING UP THE SUBSYSTEMS C1-C2-C3 -> S1-S2-S3

%% LOAD NECESSARY CODE
addpath('ft_tools');
addpath('plant');
addpath('timing');
addpath('controllers');
addpath('simulink');
addpath('results');

%% LOAD PLANT MODEL: state-space space representation of CT
plant_model;

%% CT state-space representation of plant for controller design using sample data model
C = [1 0 0 0];
D = 0;

sysc    = ss(Ac_plant, Bc_plant, C, D);
dim     = length(Ac_plant); % continuos time system state-space dimension

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