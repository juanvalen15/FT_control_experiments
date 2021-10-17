%% Markov process model of Fault-Tolerant Switching Mechanism
%%
n = 1;

LOOPS = sim_loops; % iterations variable
Ps = Ps_sim;
ps_granularity = Ps_granularity_sim; % granularity of Ps
PLOTS = Plots_on_off; % options for data and visualization



temp_mean_probability_BL_M1 = [];

for i = 1:n
    Pfm(i)  = ( nchoosek(2^(i+1), 2^(i+1) - 1) * ( Ps^( 2^(i+1) - 1 ) ) * ( 1 - Ps ) ); % [mark]: add prob. Ps^(2^i + 1)
    tm(i)   = 2^(i+1); % [slots]
end

Pfm

% matrices: probability and time
matrices_mode_BL_M1;


%% iterations test
state_BL_M1(1,:) = [1 0];
max_T_BL_M1 = max(T_BL_M1);
time_BL_M1(1,:) = [0 0];

for i = 2:LOOPS
    state_BL_M1(i,:) = state_BL_M1(i-1,:) * M_BL_M1;
    DELTA_T_BL_M1 = max_T_BL_M1( find( state_BL_M1(i,:)==max(state_BL_M1(i,:)) ) );
    time_BL_M1(i,:)  = time_BL_M1(i-1,:) + DELTA_T_BL_M1;
end


%%
t_BL_M1 = time_BL_M1(:,end);
R_BL_M1 = 1-state_BL_M1(:,end);

t_N1{1} = t_BL_M1;
R_N1{1} = R_BL_M1;


%%
if PLOTS == 1
    
    figure;
    plot(t_BL_M1, R_BL_M1, 'r-.', 'linewidth', 1, 'DisplayName', 'BL - n = 1 with mode 1'); hold on;
    
    
    ylabel('Reliability [probability]');
    xlabel('Time [slots]');
    grid on;
    grid minor;
    %ylim([0 1]);
    xlim([0 1000]);
    
    legend(gca, 'show','location', 'best');
    
end





