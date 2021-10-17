%% Markov process model of Fault-Tolerant Switching Mechanism
%% clear all
clear all;
close all;
clc;

%%
n = 3;

fsw{1} = [1 1 1];
fsw{2} = [4 4 4];


LOOPS = 10000; % iterations variable

min_ps = 0.1;
max_ps = 0.1;
ps_granularity = 0.1; % granularity of Ps


% options for data and visualization
SAVE_DATA = 0; % option to save data along the iterations
PLOT_BY_PS = 1; % plots for each ps given f
PLOT_BY_SW_SEQUENCE = 0; % plots for all ps for all f sequences

for sequence = 1:length(fsw)
    
    f = fsw{sequence};
    
    exp = 0;
    
    temp_mean_probability_BL_M1 = [];
    temp_mean_probability_BL_M2 = [];
    temp_mean_probability_BL_M3 = [];
    
    temp_mean_probability_N1 = [];
    temp_mean_probability_N2 = [];
    temp_mean_probability_N3 = [];
    
    for Ps = min_ps:ps_granularity:max_ps % varying probability of a fault in an application slot
        
        exp = exp + 1; % just a counter for Ps index
        
        for i = 1:n
            Pfm(i)  = nchoosek(2^(i+1), 2^(i+1) - 1) * ( Ps^( 2^(i+1) - 1 ) ) * ( 1 - Ps );
            tm(i)   = 2^(i+1); % [slots]
        end
        
        Pfm
        
        x1 = ( 1-Pfm(1) )^( f(1)-1 );
        x2 = ( 1-Pfm(2) )^( f(2)-1 );
        x3 = ( 1-Pfm(3) )^( f(3)-1 );
        
        y1 = 0;
        for temp_index = 1:f(1)-1
            y1 = y1 + ( (1-Pfm(1))^(temp_index-1) )*Pfm(1);
        end
        
        y2 = 0;
        for temp_index = 1:f(2)-1
            y2 = y2 + ( (1-Pfm(2))^(temp_index-1) )*Pfm(2);
        end
        
        y3 = 0;
        for temp_index = 1:f(3)-1
            y3 = y3 + ( (1-Pfm(3))^(temp_index-1) )*Pfm(3);
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
        state_N2(1,:) = [1 0 0 0 0 0 0 0 0];
        state_N3(1,:) = [1 0 0 0 0 0 0 0 0 0 0 0 0 0];
        
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
        
        
        if SAVE_DATA == 1
            save(['R_3n_' num2str(Ps) '.mat'], ...
                'state_BL', 'state_N1', 'state_N2', 'state_N3', ...
                'time_BL', 'time_N1', 'time_N2', 'time_N3');
        end
        
        
        
        %%
        if PLOT_BY_PS == 1
            figure;
            
            subplot(1,3,1);
            plot(time_BL_M1(:,end), 1-state_BL_M1(:,end), 'r-.', 'linewidth', 2); hold on;
            plot(time_N1(:,end), 1-state_N1(:,end), 'g-.', 'linewidth', 2); hold on;
            plot(time_N2(:,end), 1-state_N2(:,end), 'b-.', 'linewidth', 2); hold on;
            plot(time_N3(:,end), 1-state_N3(:,end), 'm-.', 'linewidth', 2); hold on;            
            ylabel('Reliability: (1-P_{instability})');
            xlabel('Slots');         
            grid on;
            grid minor;            
            ylim([0 1]);            
            legend('n=1 BL','n=1','n=2 f=[1 1]', 'n=3 f=[1 1 1]', 'location', 'best');
            
            subplot(1,3,2);
            plot(time_BL_M2(:,end), 1-state_BL_M2(:,end), 'r-', 'linewidth', 2); hold on;
            plot(time_N1(:,end), 1-state_N1(:,end), 'g-.', 'linewidth', 2); hold on;
            plot(time_N2(:,end), 1-state_N2(:,end), 'b-.', 'linewidth', 2); hold on;
            plot(time_N3(:,end), 1-state_N3(:,end), 'm-.', 'linewidth', 2); hold on;            
            ylabel('Reliability: (1-P_{instability})');
            xlabel('Slots');         
            grid on;
            grid minor;            
            ylim([0 1]);            
            legend('n=2 BL','n=1','n=2 f=[1 1]', 'n=3 f=[1 1 1]', 'location', 'best');
            
            subplot(1,3,3);
            plot(time_BL_M3(:,end), 1-state_BL_M3(:,end), 'r-', 'linewidth', 2); hold on;
            plot(time_N1(:,end), 1-state_N1(:,end), 'g-.', 'linewidth', 2); hold on;
            plot(time_N2(:,end), 1-state_N2(:,end), 'b-.', 'linewidth', 2); hold on;
            plot(time_N3(:,end), 1-state_N3(:,end), 'm-.', 'linewidth', 2); hold on;            
            ylabel('Reliability: (1-P_{instability})');
            xlabel('Slots');         
            grid on;
            grid minor;            
            ylim([0 1]);            
            legend('n=3 BL','n=1','n=2 f=[1 1]', 'n=3 f=[1 1 1]', 'location', 'best');
                                   
            Ps
        end
        
        %% settling time: estimatio of the probability of being reliable
        temp_reliability_BL_M1  = 1-state_BL_M1(end,:);
        temp_reliability_N1     = 1-state_N1(end,:);
        temp_reliability_N2     = 1-state_N2(end,:);
        temp_reliability_N3     = 1-state_N3(end,:);
        
        temp_mean_probability_BL_M1 = [temp_mean_probability_BL_M1; mean(state_BL_M1)];
        temp_mean_probability_N1    = [temp_mean_probability_N1; mean(state_N1)];
        temp_mean_probability_N2    = [temp_mean_probability_N2; mean(state_N2)];
        temp_mean_probability_N3    = [temp_mean_probability_N3; mean(state_N3)];
        
        % Settling probability
        TH = 0.00000001;
        
        info_temp_BL_M1         = stepinfo(temp_reliability_BL_M1,'SettlingTimeThreshold',TH);
        settling_temp_BL_M1     = ceil(info_temp_BL_M1.SettlingTime);
        reliability_BL_M1(exp)  = temp_reliability_BL_M1(settling_temp_BL_M1);
        
        info_temp_N1        = stepinfo(temp_reliability_N1,'SettlingTimeThreshold',TH);
        settling_temp_N1    = ceil(info_temp_N1.SettlingTime);
        reliability_N1(exp) = temp_reliability_N1(settling_temp_N1);
        
        info_temp_N2        = stepinfo(temp_reliability_N2,'SettlingTimeThreshold',TH);
        settling_temp_N2    = ceil(info_temp_N2.SettlingTime);
        reliability_N2(exp) = temp_reliability_N2(settling_temp_N2);
        
        info_temp_N3        = stepinfo(temp_reliability_N3,'SettlingTimeThreshold',TH);
        settling_temp_N3    = ceil(info_temp_N3.SettlingTime);
        reliability_N3(exp) = temp_reliability_N3(settling_temp_N3);
        
    end
    
    reliability_array_BL_M1{sequence} = reliability_BL_M1;
    reliability_array_N1{sequence} = reliability_N1;
    reliability_array_N2{sequence} = reliability_N2;
    reliability_array_N3{sequence} = reliability_N3;
    
    mean_BL_M1{sequence} = temp_mean_probability_BL_M1;
    mean_N1{sequence} = temp_mean_probability_N1;
    mean_N2{sequence} = temp_mean_probability_N2;
    mean_N3{sequence} = temp_mean_probability_N3;
    
end





%%
if PLOT_BY_SW_SEQUENCE == 1
    figure;
    plot(reliability_array_BL_M1{1}, 'r-o'); hold on;
    plot(reliability_array_N1{1}, 'g-o'); hold on;
    plot(reliability_array_N2{1}, 'b-o'); hold on;
    plot(reliability_array_N2{2}, 'b->'); hold on;
    plot(reliability_array_N3{1}, 'm-o'); hold on;
    plot(reliability_array_N3{2}, 'm->'); hold on;
    ylabel('Reliability [probability of being operational]');
    xlabel('Ps [probability of fault at application slot]');
    
    labels = min_ps:ps_granularity:max_ps;
    set(gca, 'XTick', 1:length(labels)); % Change x-axis ticks
    set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.
    
    grid on;
    grid minor;
    
    ylim([0 1]);
    
    legend('n=1 BL','n=1','n=2 f=[1 1]', 'n=2 f=[4 4]', 'n=3 f=[1 1 1]', 'n=3 f=[4 4 4]', 'location', 'best');
end