%% CHECKING LYAPUNOV STABILITY CONDITIONS WITH DIFFERENT SWITCHING SCENARIOS
%% SWITCHING SCENARIOS VARIABLES FOR 3 SUBSYSTEMS
number_subsystems = length(S);
sw_exp_array      = (((dec2base(0:power(max_number_sw,number_subsystems)-1,max_number_sw) - '0') + 1));

sw_exp_s1 = sw_exp_array(:,1);
sw_exp_s2 = sw_exp_array(:,2);
sw_exp_s3 = sw_exp_array(:,3);

%% SWITCHING EXPLORATION
working_sequences = [];

for i = 1:length(sw_exp_array)
    %% Variable
    P = sdpvar(dim+1, dim+1, 'symmetric');
    
    %% Tolerance
    tol = 1e-7;
    
    %% Lyapunov functions for the sybsystems    
    L1 = [(transpose(S1^sw_exp_s1(i))*P*(S1^sw_exp_s1(i)) - P) < -tol];
    L2 = [(transpose(S2^sw_exp_s2(i))*P*(S2^sw_exp_s2(i)) - P) < -tol];
    L3 = [(transpose(S3^sw_exp_s3(i))*P*(S3^sw_exp_s3(i)) - P) < -tol];
    Lp = [P > tol];
    
    L = [L1, L2, L3, Lp]; % combine constraints into one object
    %% Checking if solution if feasable : solve the LMI
    options = sdpsettings('verbose',1,'solver','sedumi','sedumi.eps',1e-8); % SDP solvers=sdpt3, mosek, sedumi
    
    %% Solution
    solution = solvesdp(L, [], options);
    solution.info
    P_sol = double(P); 

    
    %% Eigenvalues check
    EIG0 = eig( P_sol );
    EIG1 = eig( transpose(S1^sw_exp_s1(i))*P_sol*(S1^sw_exp_s1(i)) - P_sol );
    EIG2 = eig( transpose(S2^sw_exp_s2(i))*P_sol*(S2^sw_exp_s2(i)) - P_sol );
    EIG3 = eig( transpose(S3^sw_exp_s3(i))*P_sol*(S3^sw_exp_s3(i)) - P_sol );
   
    
    if solution.problem == 0        
        if (any( any(EIG0 < 0) ) == 0) && (any( any(EIG1 > 0) ) == 0) && (any( any(EIG2 > 0) ) == 0) && (any( any(EIG3 > 0) ) == 0)
            working_sequences = [working_sequences; sw_exp_array(i,:)];
            disp('Feasible');
        end
    elseif solution.problem == 1
        disp('Infeasible')
    else
        disp('Something else happened')
    end
end

clear i L1 L2 L3 Lp L options solution eigenvalues 