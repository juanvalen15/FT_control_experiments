%% PLOTTING STEPS: script designed to plot response of the FT controller

%% START
fprintf('Plotting average step responses FT framework \n')

%% FIGURE SPECIFICATIONS
colorspec  = { [0 1 0]; [ 0.9290 0.6940 0.1250];[0.4660 0.6740 0.1880];[0.8500 0.3250 0.0980]; [0.2 0.2 0.2];[1 0 0];[0 0 1];[1 0 1]; [0 1 1]; [ 0.4940 0.1840 0.5560]; };  % colors for plotting ... up to ten.
markerspec = {'o','+','*','.','x','s','d','^','v','>'};
Makersize  = 4;

%% SIMULINK SIMULATION
sim('simulink_ft_fault_injection', Tend) % simulink simulation with continuous plant

%% plots
if plots_ft_sim == 1
    figure;
    % output
    sb1 = subplot(2,1,1); hold on; grid on;
    title('system output'); ylabel('Radians');
    % plot
    h1 = plot(reference_output.Time, reference_output.Data - 0.02*reference_output.Data,'LineStyle','--','color','k');
    plot(reference_output.Time, reference_output.Data + 0.02*reference_output.Data,'LineStyle','--','color','k');
    h2 = plot(sensed_data_x1.Time, sensed_data_x1.Data, '*', 'Color',colorspec{1}, 'MarkerSize', Makersize, 'Marker', markerspec{1});
    %legend
    legend([h1 h2], {'2% criteria','System output'})
    % input
    sb2 = subplot(2,1,2); hold on; grid on;
    title('controller output'); xlabel('Time [s]'); ylabel('I_{motor}');
    stairs(actuation_signal_u.Time, actuation_signal_u.Data,'-','MarkerSize',Makersize,'Color',colorspec{1},'Marker', markerspec{1});
    legend('control output')
    % axes
    linkaxes([sb1 sb2],'x'); % add markers to the graphs
    fprintf('Done \n');
end


%% ERROR
error_ft_sim = reference_output.Data-sensed_data_x1.Data;
error_bl_sim = reference_output.Data-sensed_data_x1_fixed.Data;

mean_ft_sim = mean(abs(error_ft_sim));
mean_bl_sim = mean(abs(error_bl_sim));

%% saving data
if evaluate_fsw == 1
    if evaluate_pf == 1
        save(['results/results_from_ft_framework' num2str(fsw_index) '_Pf_' num2str(pf_index) '.mat'], ...
            'working_sequences', 'reference_output', 'actuation_signal_u','sensed_data_x1','actuation_signal_u_fixed','sensed_data_x1_fixed', ...
            'error_ft_sim', 'error_bl_sim', 'mean_ft_sim', 'mean_bl_sim');
    else
        save(['results/results_from_ft_framework' num2str(fsw_index) '.mat'], ...
            'working_sequences', 'reference_output', 'actuation_signal_u','sensed_data_x1','actuation_signal_u_fixed','sensed_data_x1_fixed', ...
            'error_ft_sim', 'error_bl_sim', 'mean_ft_sim', 'mean_bl_sim');        
    end
else   
    save('results/results_from_ft_framework.mat', ...
        'reference_output', 'actuation_signal_u','sensed_data_x1','actuation_signal_u_fixed','sensed_data_x1_fixed', ...
        'error_ft_sim', 'error_bl_sim', 'mean_ft_sim', 'mean_bl_sim');
end

