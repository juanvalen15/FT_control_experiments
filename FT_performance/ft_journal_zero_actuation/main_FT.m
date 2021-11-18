%% CLEAR: all workspace and global variables, and close all figues
% clearvars -global; clearvars; close all; clc;

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
