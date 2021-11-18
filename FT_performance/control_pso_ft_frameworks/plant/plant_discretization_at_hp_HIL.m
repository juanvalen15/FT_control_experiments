%% PLANT DISCRETIZATION @ hp FOR HIL SIMULATION

%% CT AND DT state-space representation using simulink C, D configuration (to read all the states)
sysc_plant = ss(Ac_plant, Bc_plant, Cc_plant, Dc_plant);
sysd_plant  = c2d(sysc_plant, hp, 'zoh');

%% Discrete matrices and conversion to SINGLE
Ad_plant = single(sysd_plant.a);
Bd_plant = single(sysd_plant.b);
Cd_plant = single(sysd_plant.c);
Dd_plant = single(sysd_plant.d);

%% clear unecessary variables
clear sysc_plant sysd_plant