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
SIM_TIME                    = 40000; % Simulation time in seconds [s]
SIM_REFERENCE               = 0.05; % reference
% -------------------------------------------------------------------------
PLOTS_PSO_CORE_ON_OFF       = 0; % 1 = ON, 0 = OFF
PLOTS_SCRIPT_SIM_ON_OFF     = 1; % 1 = ON, 0 = OFF
MAX_PSO_LOOP                = 10; % MAX_PSO_LOOP pso controllers: to find best out of those
% -------------------------------------------------------------------------



%% NOMINAL SAMPLING PERIOD CONTROLLER DESIGN ------------------------------
% Dummy EXP value
EXP = 0;

% directory
exp_directory           = ['output/controllers'];
mkdir(exp_directory);   %create the directory

% Timing
% timings_set; % both lmi and lqr based
% replacing timings_set with fixed timing settings
% sampling periods: [10.0000e-003    20.0000e-003    40.0000e-003] seconds
% delays: [5.2000e-003    15.2000e-003    35.2000e-003] seconds


% 10-20-40 ms
% sampling_periods = [10.0000e-003    20.0000e-003    40.0000e-003];
% delays           = [5.2000e-003    15.2000e-003    35.2000e-003];

% 20-40-80 ms
sampling_periods = [20.0000e-003    40.0000e-003    80.0000e-003];
delays           = [15.2000e-003    35.2000e-003    75.2000e-003];

% 20-40-80-160 ms
sampling_periods = [20.0000e-003    40.0000e-003    80.0000e-003    160.0000e-003];
delays           = [15.2000e-003    35.2000e-003    75.2000e-003    155.2000e-003];

% 27-40-80-160-320-640-1280-2560-5120-10240 ms
sampling_periods = [20.0000e-003 ...
                    40.0000e-003 ...
                    80.0000e-003 ...
                    160.0000e-003 ...
                    320.0000e-003 ...
                    640.0000e-003 ...
                    1.2800e+000 ...
                    2.5600e+000 ...
                    5.1200e+000 ...
                    10.2400e+000];


delays = [15.2000e-003 ...
          35.2000e-003 ...
          75.2000e-003 ...
          155.2000e-003 ...
          315.2000e-003 ...
          635.2000e-003 ...
          1.2752e+000 ...
          2.5552e+000 ...
          5.1152e+000 ...
          10.2352e+000];
     
     

mode_selection      = 10;
Ts                  = sampling_periods(mode_selection)
application_delay   = delays(mode_selection)
Splant              = 100e-6;

settling_window     = Ts*10; % settling time window to observe in simulation per ref step
ref_sampling_factor = round(settling_window/Ts);


% Plant
plant; % plant
plant_discretization; % discretization

% find SR controller using PSO for the nominal sampling period
main_pso_SR_nominal_sampling;
% -------------------------------------------------------------------------



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
