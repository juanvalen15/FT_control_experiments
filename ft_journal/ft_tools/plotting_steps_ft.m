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
temp_ref_data           = reference_output.Data;
temp_ref_time           = reference_output.Time;
temp_sensed_data        = sensed_data_x1.Data;
temp_sensed_fixed_data  = sensed_data_x1_fixed.Data;

temp_ref_data           = temp_ref_data(1:end-1);
temp_ref_time           = temp_ref_time(1:end-1);
temp_sensed_data        = temp_sensed_data(1:end-1);
temp_sensed_fixed_data  = temp_sensed_fixed_data(1:end-1);

error_ft_sim = temp_ref_data - temp_sensed_data;
error_bl_sim = temp_ref_data - temp_sensed_fixed_data;

%% Integral Error Measurements
% MAE
mean_ft_sim = mean( abs(error_ft_sim) );
mean_bl_sim = mean( abs(error_bl_sim) );

% IAE
iae_ft_sim = sum( abs(error_ft_sim) );
iae_bl_sim = sum( abs(error_bl_sim) );

% ISE
ise_ft_sim = sum( error_ft_sim.^2 );
ise_bl_sim = sum( error_bl_sim.^2 );

% ITAE
itae_ft_sim = sum( temp_ref_time.*abs(error_ft_sim) );
itae_bl_sim = sum( temp_ref_time.*abs(error_bl_sim) );



table(mean_ft_sim, mean_bl_sim, iae_ft_sim, iae_bl_sim, ise_ft_sim, ise_bl_sim, itae_ft_sim, itae_bl_sim)

%% saving data
if evaluate_fsw == 1
    if evaluate_pf == 1
        save(['results/results_ft_n_' num2str(control_modes) '_fsw_' num2str(fsw_index) '_Pf_' num2str(pf_index) '.mat'], ...
            'working_sequences', 'reference_output', 'actuation_signal_u','sensed_data_x1','actuation_signal_u_fixed','sensed_data_x1_fixed', ...
            'error_ft_sim', 'error_bl_sim', 'mean_ft_sim', 'mean_bl_sim', 'iae_ft_sim', 'iae_bl_sim', 'ise_ft_sim', 'ise_bl_sim', 'itae_ft_sim', 'itae_bl_sim');
    else
        save(['results/results_ft_n_' num2str(control_modes) '_fsw_' num2str(fsw_index) '.mat'], ...
            'working_sequences', 'reference_output', 'actuation_signal_u','sensed_data_x1','actuation_signal_u_fixed','sensed_data_x1_fixed', ...
            'error_ft_sim', 'error_bl_sim', 'mean_ft_sim', 'mean_bl_sim', 'iae_ft_sim', 'iae_bl_sim', 'ise_ft_sim', 'ise_bl_sim', 'itae_ft_sim', 'itae_bl_sim');        
    end
else   
    save(['results/results_ft_n_' num2str(control_modes) '_Pf_' num2str(pf_index) '.mat'], ...
        'reference_output', 'actuation_signal_u','sensed_data_x1','actuation_signal_u_fixed','sensed_data_x1_fixed', ...
        'error_ft_sim', 'error_bl_sim', 'mean_ft_sim', 'mean_bl_sim', 'iae_ft_sim', 'iae_bl_sim', 'ise_ft_sim', 'ise_bl_sim', 'itae_ft_sim', 'itae_bl_sim');
end

