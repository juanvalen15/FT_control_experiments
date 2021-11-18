    %% COMPARING RESULTS FROM PSO/FT FRAMEWORKS TRACES

%% START
fprintf('\n Plotting PSO/FT results for comparisons \n')

%% LOAD RESULTS
% load('results_from_pso_framework_C3.mat');
%load('results_from_ft_framework.mat');
load('results_from_ft_framework1_Pf_0.4.mat');

%% Error calculation

e1 = reference_output.Data-sensed_data_x1.Data;
e2 = reference_output.Data-sensed_data_x1_fixed.Data;

mean_e1 = mean(abs(e1));
mean_e2 = mean(abs(e2));

[mean_e1, mean_e2];

%%
if plots_ft_sim == 1
    
    figure;
    p1=subplot(2,1,1);
    hold on; grid on;
    ylabel('position [radians]');
    % xlabel('time [s]');
    h1 = plot(reference_output.Time, reference_output.Data,'LineStyle','--','color','k');
    h3 = plot(sensed_data_x1.Time , sensed_data_x1.Data,'Color',colorspec{2},'MarkerSize', Makersize, 'Marker', markerspec{1});
    h4 = plot(sensed_data_x1_fixed.Time , sensed_data_x1_fixed.Data,'Color',colorspec{3},'MarkerSize', Makersize, 'Marker', markerspec{1});
    set(gca,'FontSize',11)
    
    str = legend('reference', ...
        ['fault-tolerant: $$\overline{e}$$ = ' num2str(mean_e1, '%10.4f') ' [radians]'], ...
        ['baseline: $$\overline{e}$$ = ' num2str(mean_e2, '%10.4f') ' [radians]']);
    set(str,'Interpreter','latex','fontsize',11)
    
    
    % control input
    p2=subplot(2,1,2);
    hold on; grid on;
    xlabel('time [s]');
    ylabel('motor current [A]');
    stairs2 = stairs(actuation_signal_u.Time, actuation_signal_u.Data,'-','MarkerSize',Makersize,'Color',colorspec{2},'Marker', markerspec{1});
    stairs3 = stairs(actuation_signal_u_fixed.Time, actuation_signal_u_fixed.Data,'-','MarkerSize',Makersize,'Color',colorspec{3},'Marker', markerspec{1});
    set(gca,'FontSize',11)
    
    linkaxes([p1,p2],'x')
    
end

%%
fprintf('Done \n');