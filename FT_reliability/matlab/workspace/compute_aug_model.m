function [phi_aug, gamma_aug, C_aug] = compute_aug_model(Ts, delay)

%% controllable decomposition using example code
[A2,B2,C2,T,k] = ctrbf(A,B,C);
 
%% get controllable matix
A2c= A2(2:5,2:5);
B2c = B2(2:5);
C2c = C2(2:5);

%% model for Delay < h
phi = expm(A2c*Ts);
Gamma0 = inv(A2c)*(expm(A2c*(Ts-delay))-expm(A2c*0))*B2c;
Gamma1 = inv(A2c)*(expm(A2c*Ts)-expm(A2c*(Ts-delay)))*B2c;

phi_aug = [phi  Gamma1;zeros(1,5)];
gamma_aug = [Gamma0; 1];
C_aug = [C2c 0];