function [phi_aug, Gamma_aug, C_aug,K, F, cqlf_Ai] = model_compute(Ts,delay,Q_multiplier,R)

vx = 15; %m/s
LL = 15;  %m
m = 1590; %mass of car(kg)
I_psi = 2920; %interia of CG(kg*m^2)
l_f = 1.22; %distance from CG to front axle(m)
l_r = 1.62; %distance from CG to rear axle (m)
c_f = 2 * 60000 %(N/rad)
c_r = 2 * 60000; %cornering stiffness is increased by factor 2 -> 2 tires lumped together (N/rad)

a1 = c_f + c_r;
a2 = c_r * l_r - c_f * l_f;
a3 = -l_f * c_f + l_r * c_r;
a4 = l_f^2 * c_f + l_r^2 * c_r;
b1 = c_f / m;
b2 = l_f * c_f / I_psi;

%% state parameter description
% x1 is Vy
% x2 is yaw rate(rad/s)
% x3 is yL ==> F(S)=yL(S)/KL(S)
% x4 is epsilon_L

A = [-a1/(m*vx)     (a2-m*vx^2)/(m*vx)   0   0   0;
     a3/(I_psi*vx)  -a4/(I_psi*vx)       0   0   0;
     -1             -LL                  0   vx  0;
     0              -1                   0   0   vx;
     0              0                    0   0   0];
 
B = [b1; b2; 0; 0; 0];
C= [0 0 1 0 0];

%% State Space model from Yafei Wang's thesis: pg 25 --> converted to SISO steering angle
% A = [-a1/(m*vx)     -1+(a2/m*vx^2)   0   0 ;
%      a3/(I_psi)  -a4/(I_psi*vx)       0   0  ;
%      0             1                  0   0 ;
%      vx              LL                   vx   0  ];
%  
% B = [b1/vx; b2; 0; 0];
% C= [0 0 0 1];

%model delay
%% controllable decomposition using example code
[A2,B2,C2,T,k] = ctrbf(A,B,C);

%% get controllable matix
A2c= A2(2:5,2:5);
B2c = B2(2:5);
C2c = C2(2:5);
%C2c = [0 0 1 0];

% sysc = ss(A2c,B2c,C2c,0);
% clearvars A2c C2c;
% sysd = c2d(sysc, Ts); A2c = sysd.a; C2c = sysd.c;

%% model for Delay<h
phi = expm(A2c*Ts);
Gamma0 = inv(A2c)*(expm(A2c*(Ts-delay))-expm(A2c*0))*B2c;
Gamma1 = inv(A2c)*(expm(A2c*Ts)-expm(A2c*(Ts-delay)))*B2c;

%% design gain
phi_aug = [phi  Gamma1;zeros(1,5)];
% phi_aug = [A2c  Gamma1;zeros(1,5)]
Gamma_aug = [Gamma0; 1];
C_aug = [C2c 0];

Q = Q_multiplier*(C_aug') * C_aug;
[X,L,G]= dare(phi_aug,Gamma_aug,Q,R);
K = -G;
cqlf_Ai= phi_aug + (Gamma_aug*K);
F = 1/(C_aug*inv(eye(5)-(phi_aug+Gamma_aug*K))*Gamma_aug);

