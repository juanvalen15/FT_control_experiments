%% PLOTTING STEPS: script designed to plot response of the PSO controller
%%  USER PARAMETERS
x0          = zeros(1,n)-0; % initial states.
Speed_noise = 1E-9;

%% START
fprintf('Plotting average step responses PSO framework \n')

%% FIGURE SPECIFICATIONS
colorspec  = { [0 1 0]; [ 0.9290 0.6940 0.1250];[0.4660 0.6740 0.1880];[0.8500 0.3250 0.0980]; [0.2 0.2 0.2];[1 0 0];[0 0 1];[1 0 1]; [0 1 1]; [ 0.4940 0.1840 0.5560]; };  % colors for plotting ... up to ten.
markerspec = {'o','+','*','.','x','s','d','^','v','>'};
Makersize  = 4;

%% VARIABLES DEFINITIONS AND INITIALIZATION WITH BEST PERFORMANCE FOUND BY PSO
Settling_times = zeros(1,1);       % vector of settling times
Settling       = X_best(end-2,:);  % extracts the settling times
GB             = mean(Settling);   % finds average performance
tol            = 0.00;
ind            = [];            % range around the average to look

while isempty(ind)
    ind = find(Settling >= GB*(1-tol) & Settling <= GB*(1+tol));  %index of best performance
    tol = tol + 0.01;   % increase the tolerance
end

alpha = X_best(1:end-4,ind(1));
beta  = X_best(end-3,ind(1));
Q     = diag(alpha); % Q matrix LQR
R     = diag(beta);  % R matrix LQR

%% DISCRETIZING THE SYSTEM
[Phi,Gamma] = DiscretizeDelayShort(Ac_plant, Bc_plant, delay, Ts); % discrete time system
C_d         = [1 zeros(1,states-1)]; % Output matrix: defined for control design purposes  (one output)


%% CONTROL DESIGN OR SELECTION !!!!!!!!!!!!!!
if design_evaluation == 1
    % FINDING CONTROLLER GAINS
    K = -dlqr(Phi,Gamma,Q,R);   %feedback gain
    F = inv(C_d/(eye(states)-Phi-Gamma*K)*Gamma); % feedforward gain
else
    % USING CONTROLLERS DEPENDING ON THE EXPERIMENT: controller_experiment
    % Loading controller gains
    run('controllers/controller_gains.m');
    if controllers_index == 1
        K = K1;
        F = F1;
    end
    if controllers_index == 2
        K = K2;
        F = F2;
    end
    if controllers_index == 3
        K = K3;
        F = F3;
    end
end


%% SETTLING TIME
Settling_times(1)= setim(Ac_plant, Bc_plant, K, F, R, delay, Ts, Sett); % computes the settling time; % computes the settling time
fprintf('\nExpected settling time with is: %d \n', Settling_times(1)) % shows expected settling time

%% CONVERTING TO SINGLE AFTER USING THEM IN SETTIM (NEEDS TO BE DOUBLE): FOR SIMULATION PURPOSES
K = single(K);
F = single(F);

%% PARAMETERS FOR SIMULATION
% Tend  = Settling_times(1)*20;
h     = Ts;
pipes = 1; % update sample period variable for simulink simulation

%% SIMULINK SIMULATION
sim('simulink_pso', Tend) % simulink simulation with continuous plant


%% PLOTS

if plots_modes == 1
    figure;

    % output
    sb1 = subplot(2,1,1); hold on; grid on;
    title('system output'); ylabel('Radians');
    % plot
    h1 = plot(reference_output.Time, reference_output.Data - 0.02*reference_output.Data,'LineStyle','--','color','k');
    h2 = plot(reference_output.Time, reference_output.Data + 0.02*reference_output.Data,'LineStyle','--','color','k');
    h3 = plot(Out_sampled(:,1), Out_sampled(:,2), '*', 'Color',colorspec{1}, 'MarkerSize', Makersize, 'Marker', markerspec{1});
    %legend
    legend([h1 h3], {'2% criteria', 'System output'});

    % input
    sb2 = subplot(2,1,2); hold on; grid on;
    title('controller output'); xlabel('Time [s]'); ylabel('I_{motor}');
    stairs(Ua2.time,Ua2.Data,'-','MarkerSize',Makersize,'Color',colorspec{1},'Marker', markerspec{1});
    legend('control input')

    % axes
    linkaxes([sb1 sb2],'x'); % add markers to the graphs
end


%% QoC and Error
% QoC
time            = reference_output.Time;
step_info       = stepinfo( Out_sampled(1:ref_sampling_factor,2) );
settling_time   = time( ceil( step_info.SettlingTime ) );
qoc             = 1/settling_time;

% error
error           = reference_output.Data - Out_sampled(:,2);
mean_abs_error  = mean(abs(error)); 


%% save
save(['results/results_from_pso_framework_C' num2str(controllers_index) '.mat'], ...
     'Ts', 'delay', 'K', 'F', ...
     'reference_output', 'Out_sampled', 'Ua2', ...
     'mean_abs_error', 'settling_time', 'qoc');
 
%% done
fprintf('Done \n'); 