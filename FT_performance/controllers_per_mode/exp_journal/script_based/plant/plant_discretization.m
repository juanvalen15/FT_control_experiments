%% Plant discretizations for discrete plant in Simulink and controllers design
%% PLANT DISCRETIZATION @ hp FOR HIL SIMULATION
% CT AND DT state-space representation using simulink C, D configuration (to read all the states)
sysc_plant = ss(Ac, Bc, Cc, Dc);
sysd_plant  = c2d(sysc_plant, Splant, 'zoh');

% Discrete matrices and conversion to SINGLE
Ad_plant = single(sysd_plant.a);
Bd_plant = single(sysd_plant.b);
Cd_plant = single(sysd_plant.c);
Dd_plant = single(sysd_plant.d);


%% CONTROLLER DISCRETIZATIONS AND AUGMENTATION
% varying C and D for control design
C = [1 0 0 0];
D = 0;
sysc = ss(Ac, Bc, C, D);
dim = length(Ac);

for i = 1:length(sampling_periods)
    hs      = sampling_periods(i);
    delay   = delays(i); % this was set in timings_set.m
    sysd    = c2d(sysc, hs); 

    Ad{i} = sysd.a; 
    Bd{i} = sysd.b; 
    Cd{i} = sysd.c;

    sysd_b0 = c2d(sysc, hs-delay); 
    sysd_b1 = c2d(sysc, hs); 
    B_0{i} = sysd_b0.b;
    B_temp = sysd_b1.b;
    B_1{i} = B_temp - B_0{i};

    A_aug{i} = [Ad{i}  B_1{i}; zeros(1,dim+1)];
    B_aug{i} = [B_0{i}; 1];
    C_aug{i} = [Cd{i} 0];
    D_aug{i} = 0;
end


%% HIL PLANT @ discrete time system
sysd_HIL    = c2d(sysc, Splant); 

Ad_HIL = sysd_HIL.a; 
Bd_HIL = sysd_HIL.b; 
Cd_HIL = sysd_HIL.c;
