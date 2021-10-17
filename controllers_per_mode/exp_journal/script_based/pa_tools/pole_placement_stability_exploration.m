%% Platform Aware control design for stability exploration
% this script does the closed-loop poles exploration and it saves an output
% file that contains the set of poles that solely satisfy the stability
% requirements


%% Desired poles set. Varying 0.1:0.1:0.9 
% big set
% desired_poles = 0.1 *(((dec2base(0:power(9,dim+1)-1,9) - '0') + 1));

% small set
desired_poles = [.1 .1 .1 .1 .1;
                 .2 .2 .2 .2 .2;
                 .3 .3 .3 .3 .3;
                 .4 .4 .4 .4 .4;
                 .5 .5 .5 .5 .5;
                 .6 .6 .6 .6 .6;
                 .7 .7 .7 .7 .7;
                 .8 .8 .8 .8 .8;
                 .9 .9 .9 .9 .9];
             

% variable for feasible poles set
feasible_poles_set       = [];
feasible_controllers_set = [];
number_of_systems        = length(SP);

for poles_loop_index = 1:length(desired_poles)
    %% PLATFORM AWARE
    % Pole-Placement: nominal sampling period!
    K{1}        = -acker( A_aug{1}, B_aug{1}, desired_poles(poles_loop_index,:) ); 
    Acl_nominal = A_aug{1} + B_aug{1}*K{1};

    % Linear Matrix Inequality (LMI): switching sampling period different than nominal!
    Y = sdpvar(dim+1,dim+1,'symmetric'); 

    LY = [Y >= 0];
    L1 = [[Y   -Y*transpose(Acl_nominal); -Acl_nominal*Y  Y] >= 0];    
    for i = 1:number_of_systems-1 % sampling periods different than nominal
        Z{i} = sdpvar(1,dim+1); 
        Lsp_array{i} = [[Y, -Y*transpose(A_aug{i+1}) - transpose(Z{i})*transpose(B_aug{i+1}); -A_aug{i+1}*Y - B_aug{i+1}*Z{i}, Y] >= 0];    
    end

    Lsp = [];
    for i = 1:number_of_systems-1
        Lsp = [Lsp Lsp_array{i}];
    end

    L = [LY, L1, Lsp];

    options = sdpsettings('verbose',1,'solver','sedumi','sedumi.eps',1e-8); % SDP solvers=sdpt3, mosek, sedumi
    diagnostics = optimize(L, [], options);
    
    % solution
    solution = solvesdp(L);
    Y = double(Y);
    P = inv(Y);

    for i = 1:number_of_systems-1
        Z{i}   = double(Z{i});
        K{i+1} = Z{i}*P;
    end
    
 
    % LMIs check ----------------------------------------------------------
    eigenvalues = [];                 
    eigenvalues = [eig( [value(Y)   -value(Y)*transpose(Acl_nominal); -Acl_nominal*value(Y)  value(Y)] ); ...
                   eig( value(Y) )];            
    for i = 2:number_of_systems % for loop for the non-nominal systems
        eigenvalues = [eigenvalues; 
                       eig( [value(Y), -value(Y)*transpose(A_aug{i}) - transpose(Z{i-1})*transpose(B_aug{i}); -A_aug{i}*value(Y) - B_aug{i}*Z{i-1}, value(Y)] ); ...
                       ];
    end
    % ---------------------------------------------------------------------

    if diagnostics.problem == 0
        if (any(eigenvalues < 0) == 0)
            disp('Feasible')
            feasible_poles_set = [feasible_poles_set; desired_poles(poles_loop_index,:)];
            feasible_controllers_set = [feasible_controllers_set; K];
        else
            disp('Feasible but did not pass eingenvalues check')
        end                                    
    elseif diagnostics.problem == 1
        disp('Infeasible')
    else
        disp('Something else happened')
    end
end

%% SAVE
% SAVING CONTROLLERS
if Do_SAVE_LMI_CONTROLLERS == 1
    save(['output/feasible_controllers/feasible_controllers_lmi_poleplacement.mat'],'feasible_controllers_set','feasible_poles_set');
end  






