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

S1F = A_aug{1};
S2F = A_aug{2};
S3F = A_aug{3};


%% define unknown variables
n = size(A_aug{1},1);
[n1, m] = size(B_aug{1});

P = sdpvar(n,n);

%%
% Tolerance
tol = 1e-7;

% Dwell time
T = 4;

M1 = [S1' * P*S1 -P];
M2 = [S2' * P*S2 -P];
M3 = [S3' * P*S3 -P];

M4 = [S1F' * P*S1F -P];
M5 = [S2F' * P*S2F -P];
M6 = [S3F' * P*S3F -P];


% consrtraints
const = [M1 <= tol, M2 <= tol, M3 <= tol, ...
         M4 <= tol, M5 <= tol, M6 <= tol, ...
         -P<=tol];

     
options = sdpsettings('verbose',1,'solver','sedumi','sedumi.eps',1e-8);
solution = solvesdp(const, [], options);
solution.info

P_sol = double(P);


% Eigenvalues check
EIG0 = eig( P_sol );
EIG1 = eig( transpose(S1^T)*P_sol*(S1^T) - P_sol );
EIG2 = eig( transpose(S2^T)*P_sol*(S2^T) - P_sol );
EIG3 = eig( transpose(S3^T)*P_sol*(S3^T) - P_sol );   

EIG4 = eig( transpose(S1F^T)*P_sol*(S1F^T) - P_sol );   
EIG5 = eig( transpose(S2F^T)*P_sol*(S2F^T) - P_sol );   
EIG6 = eig( transpose(S3F^T)*P_sol*(S3F^T) - P_sol );   

if solution.problem == 0        
    if (any( any(EIG0 < 0) ) == 0) && ...
       (any( any(EIG1 > 0) ) == 0) && ...
       (any( any(EIG2 > 0) ) == 0) && ...
       (any( any(EIG3 > 0) ) == 0) && ...
       (any( any(EIG4 > 0) ) == 0) && ...
       (any( any(EIG5 > 0) ) == 0) && ...
       (any( any(EIG6 > 0) ) == 0)
       disp('Feasible');
    else
       disp('Did not pass individual LMIs tests!');
    end
elseif solution.problem == 1
    disp('Infeasible')
else
    disp('Something else happened')
end


