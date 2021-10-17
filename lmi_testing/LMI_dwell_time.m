%% solution of optimal control problem
clear all;
close all;
clc;

%% system matrices
load lmi_test_dt_sys.mat;

%% define closed loop systems
S1 = A_aug{1} + B_aug{1}*K1;
S2 = A_aug{2} + B_aug{2}*K2;
S3 = A_aug{3} + B_aug{3}*K3;


%% define unknown variables
n = size(A_aug{1},1);
[n1, m] = size(B_aug{1});

P1 = sdpvar(n,n);
P2 = sdpvar(n,n);
P3 = sdpvar(n,n);
% T  = sdpvar(m);

%%
% Tolerance
tol = 1e-7;

% dwell time
T = 4;

M1 = [S1' * P1*S1 -P1];
M2 = [S2' * P2*S2 -P2];
M3 = [S3' * P3*S3 -P3];

M4 = [((S1')^T) * P2*(S1^T) -P1];
M5 = [((S1')^T) * P3*(S1^T) -P1];

M6 = [((S2')^T) * P1*(S2^T) -P2];
M7 = [((S2')^T) * P3*(S2^T) -P2];

M8 = [((S3')^T) * P1*(S3^T) -P3];
M9 = [((S3')^T) * P2*(S3^T) -P3];

% consrtraints
const = [M1 <= tol, M2 <= tol, M3 <= tol, ...
         M4 <= tol, M5 <= tol, ...
         M6 <= tol, M7 <= tol, ...
         M8 <= tol, M9 <= tol, ...
         -P1<=tol, -P2<=tol, -P3<=tol, ...
         -T<=tol];

     
options = sdpsettings('verbose',1,'solver','sedumi','sedumi.eps',1e-8);
solution = solvesdp(const, [], options);
solution.info

P1 = double(P1);
P2 = double(P2);
P3 = double(P3);



