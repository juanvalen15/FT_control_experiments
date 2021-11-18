function [K, F, CQLF_Ai] = compute_controller_gains(phi_aug, gamma_aug, C_aug, R)

%% design gain
Q       = Q_multiplier*(C_aug') * C_aug;
[X,L,G] = dare(phi_aug, gamma_aug, Q, R);

K       = -G;
F       = 1/(C_aug*inv(eye(5)-(phi_aug+Gamma_aug*K))*Gamma_aug);

CQLF_Ai = phi_aug + (Gamma_aug*K);
