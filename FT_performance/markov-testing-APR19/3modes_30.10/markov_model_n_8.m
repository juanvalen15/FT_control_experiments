%% Markov process model of Fault-Tolerant Switching Mechanism
%%
n = 8;


fsw{1} = [1 1 2 2 2 3 3 3];
% fsw{1} = [1 1 1 1 1 1 1 1];
fsw{2} = [3 3 3 3 3 3 3 3];


LOOPS = sim_loops; % iterations variable
Ps = Ps_sim;
ps_granularity = Ps_granularity_sim; % granularity of Ps
PLOTS = Plots_on_off; % options for data and visualization


for sequence = 1:length(fsw) % 2 = two switching sequences [min=fast] [max=slow], e.g., [1 1] --> [3 3]
    
    f = flip(fsw{sequence});        
    
    temp_mean_probability_N8 = [];
        
    
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
    matrices_mode_N8;
    
    
    %% iterations test
    state_N8(1,:) = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];    
    max_T_N8 = max(T_N8);   
    time_N8(1,:) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];    
    
    for i = 2:LOOPS
        state_N8(i,:) = state_N8(i-1,:) * M_N8;        
        DELTA_T_N8 = max_T_N8( find( state_N8(i,:)==max(state_N8(i,:)) ) );               
        time_N8(i,:)  = time_N8(i-1,:) + DELTA_T_N8;        
    end
    
    
    %%
    t_N8{sequence} = time_N8(:,end);    
    R_N8{sequence} = 1-state_N8(:,end);
        
end



%%
if PLOTS == 1
    
    figure;
    
    for i=1:length(fsw)
        if i == 1
            plot(t_N8{i}, R_N8{i}, 'g-*', 'linewidth', 1, 'DisplayName', ['n = 8 f=[' num2str(fsw{i}) ']']); hold on;
        else
            plot(t_N8{i}, R_N8{i}, 'b-*', 'linewidth', 1, 'DisplayName', ['n = 8 f=[' num2str(fsw{i}) ']']); hold on;
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





