%% Markov process model of Fault-Tolerant Switching Mechanism

%%
n = 2;

fsw{1} = [2 2];
% fsw{1} = [1 1];
fsw{2} = [3 3];


LOOPS = sim_loops; % iterations variable
Ps = Ps_sim;
ps_granularity = Ps_granularity_sim; % granularity of Ps
PLOTS = Plots_on_off; % options for data and visualization

for sequence = 1:length(fsw) % 2 = two switching sequences [min=fast] [max=slow], e.g., [1 1] --> [3 3]
    
    f = flip(fsw{sequence});        
        
    temp_mean_probability_N2 = [];   
            
    for i = 1:n
        Pfm(i)  = ( nchoosek(2^(i+1), 2^(i+1) - 1) * ( Ps^( 2^(i+1) - 1 ) ) * ( 1 - Ps ) ); % [mark]: add prob. Ps^(2^i + 1)
        tm(i)   = 2^(i+1); % [slots]
    end
    
    Pfm
    
    
    y1 = 0;
    if f(1)-1 == 0
        x1 = ( 1-Pfm(1) );
        y1 = Pfm(1);
    else
        x1 = ( 1-Pfm(1) )^( f(1)-1 );
        for temp_index = 1:f(1)-1
            y1 = y1 + ( (1-Pfm(1))^(temp_index-1) )*Pfm(1);
        end
    end
    
    y2 = 0;
    if f(2)-1 == 0
        x2 = ( 1-Pfm(2) );
        y2 = Pfm(2);
    else
        x2 = ( 1-Pfm(2) )^( f(2)-1 );
        for temp_index = 1:f(2)-1
            y2 = y2 + ( (1-Pfm(2))^(temp_index-1) )*Pfm(2);
        end
    end
    
    
    % matrices: probability and time 
    matrices_mode_N2;
    
    
    %% iterations test
    state_N2(1,:) = [1 0 0 0 0];    
    max_T_N2 = max(T_N2);        
    time_N2(1,:) = [0 0 0 0 0 0 0 0 0];
    
    
    for i = 2:LOOPS
        state_N2(i,:) = state_N2(i-1,:) * M_N2;
        DELTA_T_N2 = max_T_N2( find( state_N2(i,:)==max(state_N2(i,:)) ) );        
        time_N2(i,:)  = time_N2(i-1,:) + DELTA_T_N2;
    end
    
    
    %%
    t_N2{sequence} = time_N2(:,end);
    R_N2{sequence} = 1-state_N2(:,end);
        
end



%%
if PLOTS == 1
    
    figure;
    
    for i=1:length(fsw)
        if i == 1
            plot(t_N2{i}, R_N2{i}, 'g-o', 'linewidth', 1, 'DisplayName', ['n = 2 f=[' num2str(fsw{i}(1:2)) ']']); hold on;
        else
            plot(t_N2{i}, R_N2{i}, 'b-o', 'linewidth', 1, 'DisplayName', ['n = 2 f=[' num2str(fsw{i}(1:2)) ']']); hold on;
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





