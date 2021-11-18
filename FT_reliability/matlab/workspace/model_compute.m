function [A_aug, B_aug, C_aug,K, F] = model_compute(Ts,delay,Q_multiplier,R)

% lego ev3 large motor estimated parameters with speed control
b_plant = 0.2895;
J_plant = 0.0288;
K_plant = 0.2964;
L_plant = 0.0288;
R_plant = 0.2895;

A = [0 1 0; ...
     0 -b_plant/J_plant K_plant/J_plant; ...
     0 -K_plant/J_plant -R_plant/L_plant];
B = [0; 0; 1/L_plant];
C = [1 0 0];
D = 0;

%% model for delay < h
dim = length(A);

sysc = ss(A,B,C,D);
sysd = c2d(sysc,Ts);

Ad = sysd.a;
Bd = sysd.b;
Cd = sysd.c;

sysd_b0 = c2d(sysc, Ts-delay);
sysd_b1 = c2d(sysc, Ts);

B0 = sysd_b0.b;
B_temp = sysd_b1.b;
B1 = B_temp - B0;

%% design gain
A_aug = [Ad  B1; zeros(1,dim+1)];
B_aug = [B0; 1];
C_aug = [Cd 0];

Q = Q_multiplier*(C_aug') * C_aug;

[~,~,G]= dare(A_aug,B_aug,Q,R);
K = -G;

% feedforward
F = 1/( C_aug/( eye(dim+1) - (A_aug+B_aug*K) ) * B_aug);

