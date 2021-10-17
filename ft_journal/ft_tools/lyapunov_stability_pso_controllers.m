%% CHECKING LYAPUNOV STABILITY CONDITIONS WITH DIFFERENT SWITCHING SCENARIOS
%% SWITCHING SCENARIOS VARIABLES FOR 3 SUBSYSTEMS
number_subsystems = length(S);

sw_exp_array      = (((dec2base(0:power(max_number_sw,number_subsystems)-1,max_number_sw) - '0') + 1));

for i = 1:number_subsystems
    sw_exp{i} = sw_exp_array(:,i);
end


%% SWITCHING EXPLORATION
working_sequences = [];

for i = 1:length(sw_exp_array)
    % Variable
    P = sdpvar(dim+1, dim+1, 'symmetric');
    
    % Tolerance
    tol = 1e-7;
    
    % Lyapunov functions for the sybsystems
    for j = 1:number_subsystems
        L_SYS{j} = [(transpose(SYS{j}^sw_exp{j}(i))*P*(SYS{j}^sw_exp{j}(i)) - P) <= -tol];        
    end
    L_SYS{j+1} = [P >= tol];
    
    
    L = [];
    for j = 1:number_subsystems+1
        L = [L L_SYS{j}];
    end
    
    % Checking if solution if feasable : solve the LMI
    options = sdpsettings('verbose',1,'solver','sedumi','sedumi.eps',1e-8); % SDP solvers=sdpt3, mosek, sedumi
    
    %% Solution
    solution = solvesdp(L, [], options);
    solution.info
    P_sol = double(P);
    
    % Eigenvalues check
    for j = 1:number_subsystems
        EIG_SYS{j} = eig( transpose(SYS{j}^sw_exp{j}(i))*P_sol*(SYS{j}^sw_exp{j}(i)) - P_sol );
    end
    EIG_SYS{j+1} = eig( P_sol );
    
    
    if solution.problem == 0
        EIG_TEMP = 0; % initialize temporal value with 0
        for j = 1:number_subsystems+1
            if j < (number_subsystems+1)
                if (any( any(EIG_SYS{j} > 0) ) == 0)
                    EIG_TEMP = 0;
                else
                    EIG_TEMP = 1;
                    break;                
                end
            else
                if (any( any(EIG_SYS{j} < 0) ) == 0)
                    EIG_TEMP = 0;
                else
                    EIG_TEMP = 1;
                    break;                
                end                
            end
        end
        
        if EIG_TEMP == 0
            working_sequences = [working_sequences; sw_exp_array(i,:)];
            disp('Feasible');
        else
            disp('It did not pass manual eigenvalues check');
        end
        

    elseif solution.problem == 1
        disp('Infeasible')
    else
        disp('Something else happened')
    end
end

clear i j L options solution