%% Markov process model of Fault-Tolerant Switching Mechanism
%%
n = 4;


fsw{1} = [1 3 2 2];
% fsw{1} = [1 1 1 1];
fsw{2} = [3 3 3 3];


LOOPS = sim_loops; % iterations variable
Ps = Ps_sim;
ps_granularity = Ps_granularity_sim; % granularity of Ps
PLOTS = Plots_on_off; % options for data and visualization


for sequence = 1:length(fsw) % 2 = two switching sequences [min=fast] [max=slow], e.g., [1 1] --> [3 3]
    
    f = flip(fsw{sequence});        
    
    temp_mean_probability_N4 = [];
        
    
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

    y4 = 0;
    if f(4)-1 == 0
        x4 = ( 1-Pfm(4) );
        y4 = Pfm(4);
    else
        x4 = ( 1-Pfm(4) )^( f(4)-1 );
        for temp_index = 1:f(4)-1
            y4 = y4 + ( (1-Pfm(4))^(temp_index-1) )*Pfm(4);
        end
    end    
    
    % matrices: probability and time
    matrices_mode_N4;
    
    
    %% iterations test
    state_N4(1,:) = [1 0 0 0 0 0 0 0 0 0 0];    
    max_T_N4 = max(T_N4);   
    time_N4(1,:) = [0 0 0 0 0 0 0 0 0 0 0];    
    
    for i = 2:LOOPS
        state_N4(i,:) = state_N4(i-1,:) * M_N4;        
        DELTA_T_N4 = max_T_N4( find( state_N4(i,:)==max(state_N4(i,:)) ) );               
        time_N4(i,:)  = time_N4(i-1,:) + DELTA_T_N4;        
    end
    
    
    %%
    t_N4{sequence} = time_N4(:,end);    
    R_N4{sequence} = 1-state_N4(:,end);
        
end



%%
if PLOTS == 1
    
    figure;
    
    for i=1:length(fsw)
        if i == 1
            plot(t_N4{i}, R_N4{i}, 'g-*', 'linewidth', 1, 'DisplayName', ['n = 4 f=[' num2str(fsw{i}) ']']); hold on;
        else
            plot(t_N4{i}, R_N4{i}, 'b-*', 'linewidth', 1, 'DisplayName', ['n = 4 f=[' num2str(fsw{i}) ']']); hold on;
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





