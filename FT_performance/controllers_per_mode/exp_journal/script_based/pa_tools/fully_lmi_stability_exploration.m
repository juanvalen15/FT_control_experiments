%% Fully-LMI control design
% this file checks the stability for the input switching sequence set in
% timmings_set file. If the solution is feasible then the controller will
% guarantee stability for a random switching 

clear F K;

number_of_systems  = length(SP);

%% FULLY - LMI BASED CONTROL 
% Linear Matrix Inequality (LMI): switching sampling period different than nominal!
Y = sdpvar(dim+1,dim+1,'symmetric'); 

LY = [Y >= 0];
for i = 1:number_of_systems % all systems
    Z{i} = sdpvar(1,dim+1); 
    Lsp_array{i} = [[Y, -Y*transpose(A_aug{i}) - transpose(Z{i})*transpose(B_aug{i}); -A_aug{i}*Y - B_aug{i}*Z{i}, Y] >= 0];    
end

Lsp = [];
for i = 1:number_of_systems
    Lsp = [Lsp Lsp_array{i}];
end

L = [LY, Lsp];

options = sdpsettings('verbose',1,'solver','sedumi','sedumi.eps',1e-8); % SDP solvers=sdpt3, mosek, sedumi
diagnostics = optimize(L, [], options);

% solution
solution = solvesdp(L);
Y = double(Y);
P = inv(Y);

for i = 1:number_of_systems
    Z{i}   = double(Z{i});
    K{i} = Z{i}*P;
end

% obtaining the feedforward gainsclear F;
for i = 1:number_of_systems
    F{i} = inv( C_aug{i} / ( eye(dim+1) - A_aug{i} - (B_aug{i}*K{i}) ) * B_aug{i}); % feedforward gain            
end

% LMIs check ----------------------------------------------------------
eigenvalues = [];                 
eigenvalues = [eig( value(Y) )];            
for i = 1:number_of_systems % for loop for the non-nominal systems
    eigenvalues = [eigenvalues; 
                   eig( [value(Y), -value(Y)*transpose(A_aug{i}) - transpose(Z{i})*transpose(B_aug{i}); -A_aug{i}*value(Y) - B_aug{i}*Z{i}, value(Y)] ); ...
                   ];
end
% ---------------------------------------------------------------------

if diagnostics.problem == 0
    if (any(eigenvalues < 0) == 0)
        disp('Feasible')          

        % SAVING CONTROLLERS AND FLAGGING FEASIBILITY----------------------
        if Do_FULLY_LMI == 1
            save(['output/results/exp' num2str(EXP) '/FULLY_LMI/SWITCHING_CONTROLLERS.mat' ],'K','F');
        end  
        FULLY_LMI_FEASIBLE = 1;
        % -----------------------------------------------------------------
        
    else
        disp('Feasible but did not pass eingenvalues check')
    end                                    
elseif diagnostics.problem == 1
    disp('Infeasible')
else
    disp('Something else happened')
end





