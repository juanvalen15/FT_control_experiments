%% PSO ALGORITHM EXECUTION

%% CONTROLLERS PARAMETERS: SATURATION AND PSO SETTIGNS
Sat_u       = [1.5 -1.5]; % saturation for controller output [maximum minimum]  
Speed_noise = 3 * 1e-9;
[n, inp]    = size(Bc_plant); % n=states, inp=inputs
Sett        = 4; % settling time of the open loop system. it is used to compute the settling time

%% INITIALIZE PSO ALGORITHM
Cp    = 1.5;    % personal confidence
Cg    = 1.5;    % global confidence
w     = 0.5;    % inertia
res   = 1e-3;   % stopping criterion, difference in fitness among particles in the swarm
iter  = 400;    % Maximum number of iterations inside the PSO algorithm
loops = 1;      % how many times to repeat the same algorithm?

max_x = [1e-8; 1e-8; 100; 100]; % maximum deviation in all the states x, the smaller the better
max_u = 1.5; % maximum controller output

states = 1 + n;                                 % system states
m      = 200;                                   % population size
Q      = zeros(states, 1);                      % diagonal of Q matrix
R      = zeros(inp,1);                          % diagonal of R matrix
GB     = inf;                                   % global best or best settling time found. 
iters  = 0;                                     % number of iterations required to solve the problem
time   = 0;                                     % time elapsed to solve the problem
X_pb   = zeros(states+inp);                     % best swarm found
X_best = zeros(states+4, loops);                % save results X_best=[Q R Gb iters time]

for cont = 1:loops
    fprintf('\nLoop %i out of %i diagonal PSO \n', cont, loops);    
    [Q, R, X_pb, GB, iters, time] = pso_lqr_diag_general(Ac_plant, Bc_plant, Ts, delay, m, Cp, Cg, w, iter, Sett, max_x, max_u);
                                
    X_best(1:end-3,cont) = X_pb;
    X_best(end-2,cont)   = GB;
    if ( GB == inf )
        fprintf(2,'Warning, the global best was infinite! \n' )
    end
    X_best(end-1,cont) = iters;
    X_best(end,cont)   = time;  
end