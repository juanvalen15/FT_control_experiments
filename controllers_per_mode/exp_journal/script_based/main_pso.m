%% MAIN PSO

%% TO CLEAR VARIABLES
varsbefore = who; %// get names of current variables

% CLEAR: all workspace and global variables, and close all figues
%clearvars -global; clearvars; close all; clc;



%% LOAD NECESSARY CODE
addpath('pso_tools');
addpath('plant');
addpath('simulink');


%% LOOP TO CHECK FOR SATURATION -------------------------------------------
%% USER INPUT    
variable_reference_enable = 1; % 1-> simulation is done with variable reference array 0-> simulation done with a fixed reference

%% LOAD PLANT MODEL: state-space space representation of CT
plant; % load continuous time plant model
Ac_plant = Ac;
Bc_plant = Bc;
Cc_plant = [1 0 0 0]; % for control purposes
Dc_plant = 0; % for control purposes

%% CT state-space representation of plant
sysc = ss(Ac_plant, Bc_plant, Cc_plant, Dc_plant);

%% PSO ALGORITHM INITIALIZATION AND EXECUTION    
pso_execution;

%% Setting up reference
ref                 = 1;  % reference 1 [rad]: in case of no switching experiments
ref_array           = [.05 .05 0 0 .05 .05 0 0]; % references that change in time [rad]
% WARNING MODIFY THIS VALUE ACCORDINGLY
settling_window     = Ts*10; % settling time window to observe in simulation per ref step
% settling_window     = 200e-3; % settling time window to observe in simulation per ref step
ref_sampling_factor = round(settling_window/Ts);

%% PLOTTING RESULTS
Cc_plant = eye(length(Ac_plant)); 
Dc_plant = zeros(length(Ac_plant),1);    

plotting_steps_pso;                     


%% SAVE CONTROLLER TO .MAT    
save(['output/controllers/C-' num2str(PSO_index) '.mat' ],'K','F','Ts','delay','Q','R');        




%% CLEAR VARIABLES GENERATED IN THIS SCRIPT
varsafter = who; %// get names of all variables in 'varsbefore' plus variables 
varsnew = setdiff(varsafter, varsbefore); %// variables  defined in the script
clear(varsnew{:})