%% Markov process model of Fault-Tolerant Switching Mechanism

%%
n = 3;


fsw{1} = [1 1 2];
% fsw{1} = [1 1 1];
fsw{2} = [3 3 3];


LOOPS = sim_loops; % iterations variable
Ps = Ps_sim;
ps_granularity = Ps_granularity_sim; % granularity of Ps
PLOTS = Plots_on_off; % options for data and visualization


for sequence = 1:length(fsw) % 2 = two switching sequences [min=fast] [max=slow], e.g., [1 1] --> [3 3]
    
    f = flip(fsw{sequence});        
    
    temp_mean_probability_N3 = [];
        
    
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
    
    y3 = 0;
    if f(3)-1 == 0
        x3 = ( 1-Pfm(3) );
        y3 = Pfm(3);
    else
        x3 = ( 1-Pfm(3) )^( f(3)-1 );
        for temp_index = 1:f(3)-1
            y3 = y3 + ( (1-Pfm(3))^(temp_index-1) )*Pfm(3);
        end
    end
    
    % matrices: probability and time
    matrices_mode_N3;
    
    
    %% iterations test
    state_N3(1,:)   = [1 0 0 0 0 0 0 0];    
    max_T_N3        = max(T_N3);   
    time_N3(1,:)    = [0 0 0 0 0 0 0 0];    
    
    for i = 2:LOOPS
        state_N3(i,:) = state_N3(i-1,:) * M_N3;        
        DELTA_T_N3 = max_T_N3( find( state_N3(i,:)==max(state_N3(i,:)) ) );               
        time_N3(i,:)  = time_N3(i-1,:) + DELTA_T_N3;        
    end
    
    
    %%
    t_N3{sequence} = time_N3(:,end);    
    R_N3{sequence} = 1-state_N3(:,end);
        
end



%%
if PLOTS == 1
    
    figure;
    
    for i=1:length(fsw)
        if i == 1
            plot(t_N3{i}, R_N3{i}, 'g-*', 'linewidth', 1, 'DisplayName', ['n = 3 f=[' num2str(fsw{i}) ']']); hold on;
        else
            plot(t_N3{i}, R_N3{i}, 'b-*', 'linewidth', 1, 'DisplayName', ['n = 3 f=[' num2str(fsw{i}) ']']); hold on;
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





