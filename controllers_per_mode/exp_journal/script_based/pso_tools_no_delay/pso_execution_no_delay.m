%% PSO ALGORITHM EXECUTION

%% CONTROLLERS PARAMETERS: SATURATION AND PSO SETTIGNS
Speed_noise = 3 * 1e-9;
[n, inp]    = size(Bc_plant); % n=states, inp=inputs
Sett        = 2; % settling time of the open loop system. it is used to compute the settling time

%% INITIALIZE PSO ALGORITHM
Cp    = 1.5;    % personal confidence
Cg    = 1.5;    % global confidence
w     = 0.5;    % inertia
res   = 1e-3;   % stopping criterion, difference in fitness among particles in the swarm
iter  = 200;    % Maximum number of iterations inside the PSO algorithm
loops = 1;      % how many times to repeat the same algorithm?

% max_x = 0.09;   % maximum deviation in all the states x, the smaller the better
max_x = [1; 1; 100; 100];   % maximum deviation in all the states x, the smaller the better : FOR SR BASELINE SAMPLING PERIOD
max_u = 2;   % maximum controller output

states = n;                                 % system states / NO DELAY
m      = 200; % population size
Q      = zeros(states, 1);                      % diagonal of Q matrix
R      = zeros(inp,1);                          % diagonal of R matrix
GB     = inf;                                   % global best or best settling time found.
iters  = 0;                                     % number of iterations required to solve the problem
time   = 0;                                     % time elapsed to solve the problem
X_pb   = zeros(states+inp);                     % best swarm found
X_best = zeros(states+4, loops);                % save results X_best=[Q R Gb iters time]

for cont = 1:loops
    fprintf('\nLoop %i out of %i diagonal PSO \n', cont, loops);
    %     [Q, R, X_pb, GB, iters, time] = pso_lqr_diag_general_no_delay(Ac_plant, Bc_plant, Ts, delay, ...
    %                                     m, Cp, Cg, w, iter, Sett, max_x, max_u);
    
    [Q, R, X_pb, GB, iters, time, St_array] = pso_lqr_diag_general_no_delay(Ac_plant, Bc_plant, Cc_plant, Dc_plant, Ts, ...
        m, Cp, Cg, w, iter, Sett, max_x, max_u);
    
    K=-lqr(Ac_plant,Bc_plant,diag(Q),R); % feedback gain
    F=1/(Cc_plant*((-Ac_plant-Bc_plant*K)^-1)*Bc_plant); % feedforward gain
      
    
    X_best(1:end-3,cont) = X_pb;
    X_best(end-2,cont)   = GB;
    if ( GB == inf )
        fprintf(2,'Warning, the global best was infinite! \n' )
    end
    X_best(end-1,cont) = iters;
    X_best(end,cont)   = time;
end