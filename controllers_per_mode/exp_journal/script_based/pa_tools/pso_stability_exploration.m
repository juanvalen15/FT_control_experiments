%% PSO for stability exploration

%% PSO
number_of_systems        = length(SP);


%% PLATFORM AWARE
% Using PSO controller
Acl_nominal = A_aug{1} + B_aug{1}*K{1};

% Linear Matrix Inequality (LMI): switching sampling period different than nominal!
Y = sdpvar(dim+1,dim+1,'symmetric');

% LY = [Y >= 0];
% L1 = [[Y   -Y*transpose(Acl_nominal); -Acl_nominal*Y  Y] >= 0];
% for i = 1:number_of_systems-1 % sampling periods different than nominal
%     Z{i} = sdpvar(1,dim+1);
%     Lsp_array{i} = [[Y, -Y*transpose(A_aug{i+1}) - transpose(Z{i})*transpose(B_aug{i+1}); -A_aug{i+1}*Y - B_aug{i+1}*Z{i}, Y] >= 0];
% end

tol = 1e-7;

LY = [Y > tol];
L1 = [[-Y   -Y*transpose(Acl_nominal); -Acl_nominal*Y  -Y] < -tol];

Z = sdpvar(1,dim+1);
L2 = [[-Y, -Y*transpose(A_aug{2}) - transpose(Z)*transpose(B_aug{2}); -A_aug{2}*Y - B_aug{2}*Z, -Y] < -tol];

L = [LY, L1, L2];


% options = sdpsettings('verbose',1,'solver','sdpt3'); % SDP solvers=sdpt3, mosek, sedumi
options = sdpsettings('verbose',1,'solver','sedumi','sedumi.eps',1e-8); % SDP solvers=sdpt3, mosek, sedumi

% solution
solution = solvesdp(L,[],options);
solution.info
Y = double(Y);
P = inv(Y);

% extracting the feedback gains
Z     = double(Z);
K{2}  = Z*P;

% obtaining the feedforward gains
clear F;
for i = 1:number_of_systems
    F{i} = inv( C_aug{i} / ( eye(dim+1) - A_aug{i} - (B_aug{i}*K{i}) ) * B_aug{i}); % feedforward gain
end

% LMIs check ----------------------------------------------------------
eigenvalues0 = eig( value(Y) );
eigenvalues1 = eig( [-value(Y)   -value(Y)*transpose(Acl_nominal); -Acl_nominal*value(Y)  -value(Y)] );
eigenvalues2 = eig( [-value(Y), -value(Y)*transpose(A_aug{2}) - transpose(Z)*transpose(B_aug{2}); -A_aug{2}*value(Y) - B_aug{2}*Z, -value(Y)] );

% ---------------------------------------------------------------------

if solution.problem == 0
    if (any(eigenvalues0 < 0) == 0) && (any(eigenvalues1 > 0) == 0) && (any(eigenvalues2 > 0) == 0) 
        disp('Feasible')
        
        % SAVING CONTROLLERS AND FLAGGING FEASIBILITY----------------------
        if Do_LMI_PSO == 1
            save(['output/results/exp' num2str(EXP) '/LMI_PSO/SWITCHING_CONTROLLERS.mat' ],'K','F');
        end
        LMI_PSO_FEASIBLE = 1;
        % -----------------------------------------------------------------
        
    else
        disp('Feasible but did not pass eingenvalues check')
    end
elseif solution.problem == 1
    disp('Infeasible')
else
    disp('Something else happened')
end









