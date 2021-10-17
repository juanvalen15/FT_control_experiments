%% PLANT: motion system
%% CONTINUOUS TIME PATO SYSTEM MODEL: measured with CompSOC platform
% System parameters: latest working parameters
% J1 = 0.00025;   % inertia [Kgm^2]
% J2 = 0.00022;   % inertia [Kgm^2]
J1 = 0.000001;   % inertia [Kgm^2]
J2 = 0.000001;   % inertia [Kgm^2]
b1 = 0.5e-3;    % friction coefficient @ mass 1 [Nms/rad]
b2 = 0.5e-3;    % friction coefficient @ mass 2 [Nms/rad]
k  = 10.8855;   % torsional spring [Nm/rad]
d  = 0.001474;  % torsional damping [Nms/rad]
Km = 0.5;       % motor constant [vs/A]  WARNING: IS THIS CORRECT??
Ag = 1.9949;    % amplifier gain 




%% STATE-SPACE REPRESENTATIONS
% CT state-space representation of system dynamics
Ac = [0         0       1           0;  
      0         0       0           1; 
      -k/J1     k/J1    -(d+b1)/J1   d/J1; 
      k/J2      -k/J2   d/J2        -(d+b2)/J2];
Bc = [0; 0; (Ag*Km)/J1; 0];
Cc = eye(4);
Dc = [0;0;0;0];


%% VARIALBES USED FOR THE LQR-BASED CONTROL
disp('rank of Ac|Bc is: ')
rank(ctrb(Ac,Bc))
nx = size(Ac,2);
nu = size(Bc,2);


% sysc = ss(Ac,Bc, [1 0 0 0], 0);
% figure;bode(sysc);
% figure;impulse(sysc);