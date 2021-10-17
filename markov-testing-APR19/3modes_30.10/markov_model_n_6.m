%% Markov process model of Fault-Tolerant Switching Mechanism

%%
n = 6;


fsw{1} = [1 1 2 2 3 3];
% fsw{1} = [1 1 1 1 1 1];
fsw{2} = [3 3 3 3 3 3];


LOOPS = sim_loops; % iterations variable
Ps = Ps_sim;
ps_granularity = Ps_granularity_sim; % granularity of Ps
PLOTS = Plots_on_off; % options for data and visualization


for sequence = 1:length(fsw) % 2 = two switching sequences [min=fast] [max=slow], e.g., [1 1] --> [3 3]
    
    f = flip(fsw{sequence});            
    
    temp_mean_probability_N6 = [];
        
    
    for i = 1:n
        Pfm(i)  = ( nchoosek(2^(i+1), 2^(i+1) - 1) * ( Ps^( 2^(i+1) - 1 ) ) * ( 1 - Ps ) ); % [mark]: add prob. Ps^(2^i + 1)
        tm(i)   = 2^(i+1); % [slots]
    end
    
    Pfm
    
    x = zeros(1,n);
    y = zeros(1,n);    
    for i = 1:n
        if f(i)-1 == 0
            x(i) = ( 1-Pfm(i) );
            y(i) = Pfm(i);
        else
            x(i) = ( 1-Pfm(i) )^( f(i)-1 );
            for temp_index = 1:f(i)-1
                y(i) = y(i) + ( (1-Pfm(i))^(temp_index-1) )*Pfm(i);
            end
        end
    end
    
    
    % matrices: probability and time
    matrices_mode_N6;
    
    
    %% iterations test
    state_N6(1,:) = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];    
    max_T_N6 = max(T_N6);   
    time_N6(1,:) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];    
    
    for i = 2:LOOPS
        state_N6(i,:) = state_N6(i-1,:) * M_N6;        
        DELTA_T_N6 = max_T_N6( find( state_N6(i,:)==max(state_N6(i,:)) ) );               
        time_N6(i,:)  = time_N6(i-1,:) + DELTA_T_N6;        
    end
    
    
    %%
    t_N6{sequence} = time_N6(:,end);    
    R_N6{sequence} = 1-state_N6(:,end);
        
end



%%
if PLOTS == 1
    
    figure;
    
    for i=1:length(fsw)
        if i == 1
            plot(t_N6{i}, R_N6{i}, 'g-*', 'linewidth', 1, 'DisplayName', ['n = 6 f=[' num2str(fsw{i}) ']']); hold on;
        else
            plot(t_N6{i}, R_N6{i}, 'b-*', 'linewidth', 1, 'DisplayName', ['n = 6 f=[' num2str(fsw{i}) ']']); hold on;
        end
    end
    
    ylabel('Reliability [probability]');
    xlabel('Time [slots]');
    grid on;
    grid minor;
    %ylim([0 1]);
    xlim([0 1000]);
    
    legend(gca, 'show','location', 'best');
    
        
end





