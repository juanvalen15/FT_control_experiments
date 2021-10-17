%% Markov process model of Fault-Tolerant Switching Mechanism
%% clear all
clear all;
close all;
clc;

%%
n = 3;

fsw{1} = [1 1 1];
fsw{2} = [10 10 10];


LOOPS = 1000; % iterations variable

Ps = 0.5
ps_granularity = 0.1; % granularity of Ps


% options for data and visualization
PLOTS = 1;

for sequence = 1:length(fsw)
    
    f = fsw{sequence};
    
    exp = 0;
    
    temp_mean_probability_BL_M1 = [];
    temp_mean_probability_BL_M2 = [];
    temp_mean_probability_BL_M3 = [];
    
    temp_mean_probability_N1 = [];
    temp_mean_probability_N2 = [];
    temp_mean_probability_N3 = [];
    
    
    exp = exp + 1; % just a counter for Ps index
    
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
    matrices_mode_BL_M1;
    matrices_mode_BL_M2;
    matrices_mode_BL_M3;
    
    matrices_mode_N1;
    matrices_mode_N2;
    matrices_mode_N3;
    
    
    %% iterations test
    state_N1(1,:) = [1 0];
    state_N2(1,:) = [1 0 0 0 0];
    state_N3(1,:) = [1 0 0 0 0 0 0 0];
    
    state_BL_M1(1,:) = [1 0];
    state_BL_M2(1,:) = [1 0];
    state_BL_M3(1,:) = [1 0];
    
    max_T_N1 = max(T_N1);
    max_T_N2 = max(T_N2);
    max_T_N3 = max(T_N3);
    
    max_T_BL_M1 = max(T_BL_M1);
    max_T_BL_M2 = max(T_BL_M2);
    max_T_BL_M3 = max(T_BL_M3);
    
    time_N1(1,:) = [0 0];
    time_N2(1,:) = [0 0 0 0 0 0 0 0 0];
    time_N3(1,:) = [0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    
    time_BL_M1(1,:) = [0 0];
    time_BL_M2(1,:) = [0 0];
    time_BL_M3(1,:) = [0 0];
    
    for i = 2:LOOPS
        state_N1(i,:) = state_N1(i-1,:) * M_N1;
        state_N2(i,:) = state_N2(i-1,:) * M_N2;
        state_N3(i,:) = state_N3(i-1,:) * M_N3;
        
        state_BL_M1(i,:) = state_BL_M1(i-1,:) * M_BL_M1;
        state_BL_M2(i,:) = state_BL_M2(i-1,:) * M_BL_M2;
        state_BL_M3(i,:) = state_BL_M3(i-1,:) * M_BL_M3;
        
        DELTA_T_N1 = max_T_N1( find( state_N1(i,:)==max(state_N1(i,:)) ) );
        DELTA_T_N2 = max_T_N2( find( state_N2(i,:)==max(state_N2(i,:)) ) );
        DELTA_T_N3 = max_T_N3( find( state_N3(i,:)==max(state_N3(i,:)) ) );
        
        DELTA_T_BL_M1 = max_T_BL_M1( find( state_BL_M1(i,:)==max(state_BL_M1(i,:)) ) );
        DELTA_T_BL_M2 = max_T_BL_M2( find( state_BL_M2(i,:)==max(state_BL_M2(i,:)) ) );
        DELTA_T_BL_M3 = max_T_BL_M3( find( state_BL_M3(i,:)==max(state_BL_M3(i,:)) ) );
        
        time_N1(i,:)  = time_N1(i-1,:) + DELTA_T_N1;
        time_N2(i,:)  = time_N2(i-1,:) + DELTA_T_N2;
        time_N3(i,:)  = time_N3(i-1,:) + DELTA_T_N3;
        
        time_BL_M1(i,:)  = time_BL_M1(i-1,:) + DELTA_T_BL_M1;
        time_BL_M2(i,:)  = time_BL_M2(i-1,:) + DELTA_T_BL_M2;
        time_BL_M3(i,:)  = time_BL_M3(i-1,:) + DELTA_T_BL_M3;
    end
    
    
    %%
    t_BL_M1{sequence} = time_BL_M1(:,end);
    t_BL_M2{sequence} = time_BL_M2(:,end);
    t_BL_M3{sequence} = time_BL_M3(:,end);
    t_N1{sequence} = time_N1(:,end);
    t_N2{sequence} = time_N2(:,end);
    t_N3{sequence} = time_N3(:,end);
    
    R_BL_M1{sequence} = 1-state_BL_M1(:,end);
    R_BL_M2{sequence} = 1-state_BL_M2(:,end);
    R_BL_M3{sequence} = 1-state_BL_M3(:,end);
    R_N1{sequence} = 1-state_N1(:,end);
    R_N2{sequence} = 1-state_N2(:,end);
    R_N3{sequence} = 1-state_N3(:,end);
    
    
end



%%
if PLOTS == 1
    
    figure;
    plot(t_N1{1}, R_N1{1}, 'r-.', 'linewidth', 1, 'DisplayName', 'n = 1'); hold on;
    
    for i=1:length(fsw)
        if i == 1
            plot(t_N2{i}, R_N2{i}, 'g-o', 'linewidth', 1, 'DisplayName', ['n = 2 f=[' num2str(fsw{i}(1:2)) ']']); hold on;
            plot(t_N3{i}, R_N3{i}, 'g-*', 'linewidth', 1, 'DisplayName', ['n = 3 f=[' num2str(fsw{i}) ']']); hold on;
        else
            plot(t_N2{i}, R_N2{i}, 'b-o', 'linewidth', 1, 'DisplayName', ['n = 2 f=[' num2str(fsw{i}(1:2)) ']']); hold on;
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





