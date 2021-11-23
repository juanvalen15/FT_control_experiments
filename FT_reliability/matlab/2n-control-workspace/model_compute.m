function [A_aug, B_aug, C_aug, K, F] = model_compute(Ts, delay, Q_multiplier, R)
% DC motor speed model continuous time
% Model for state space
% d/dt [tetha* i]^T = A [tetha* i]^T + [0 1/L]^T V
%                 y = [1 0][tetha* i]^T  

J = 0.01; % (J) moment of inertia of the rotor 0.01 kg.m^2
b = 0.1; % (b) motor viscous friction constant 0.1 N.m.s
K = 0.01; % (Ke) electromotive force constant 0.01 V/rad/sec | % (Kt) motor torque constant 0.01 N.m/Amp | Ke = Kt
Re = 1; % (R) electric resistance 1 Ohm
L = 0.5; % (L) electric inductance 0.5 H

A = [-b/J   K/J
    -K/L   -Re/L];
B = [0
    1/L];
C = [1   0];
D = 0;

sysc    = ss(A, B, C, D);
dim     = length(A); % continuos time system state-space dimension

%% Controlability check
if (order(sysc) ~= rank(ctrb(A,B)))
    error('System is not controllable. Please find a controllable decomposition');
else
    disp('Controllable system');
end

%% model for delay < sampling interval
sysd = c2d(sysc, Ts);
Ad   = sysd.a; 
Bd   = sysd.b; 
Cd   = sysd.c;

sysd_b0 = c2d(sysc, Ts-delay); 
sysd_b1 = c2d(sysc, Ts); 
B_0     = sysd_b0.b;
B_temp  = sysd_b1.b;
B_1     = B_temp - B_0;

A_aug = [Ad  B_1; zeros(1,dim+1)];
B_aug = [B_0; 1];
C_aug = [Cd 0];
% D_aug = 0;

%% design gain
Q       = Q_multiplier * (C_aug') * C_aug;
[X,L,G] = dare(A_aug, B_aug, Q, R);
K       = -G;
F       = 1/( C_aug/( eye(dim+1)-(A_aug + B_aug * K) ) * B_aug );

