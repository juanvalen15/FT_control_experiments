%% COMPARING RESULTS FROM PSO/FT FRAMEWORKS TRACES

%% START
fprintf('\n Comparing error-free results ... \n')

%% LOAD RESULTS
load('results_from_ft_framework_mode1_10ms.mat');
a1 = actuation_signal_u_fixed;
s1 = sensed_data_x1_fixed;

load('results_from_ft_framework_mode2_20ms.mat');
a2 = actuation_signal_u_fixed;
s2 = sensed_data_x1_fixed;

load('results_from_ft_framework_mode3_40ms.mat');
a3 = actuation_signal_u_fixed;
s3 = sensed_data_x1_fixed;

load('results_from_ft_framework_reference_output_m1m2m3_10_20_40ms.mat');


%% Error
e1 = reference_output_fixed.Data - s1.Data;
e2 = reference_output_fixed.Data - s2.Data;
e3 = reference_output_fixed.Data - s3.Data;

mean_e1 = mean(abs(e1));
mean_e2 = mean(abs(e2));
mean_e3 = mean(abs(e3));


%%
figure;

hold on; grid on;
xlabel('time [s]'); ylabel('position [radians]'); 
% h1 = plot(reference_output_fixed.Time, reference_output_fixed.Data - 0.02,'LineStyle','--','color','k');
% h2 = plot(reference_output_fixed.Time, reference_output_fixed.Data + 0.02,'LineStyle','--','color','k');
h1 = plot(reference_output_fixed.Time, reference_output_fixed.Data,'LineStyle','--','color','k');

h3 = plot(s1.Time , s1.Data,'Color',colorspec{2},'MarkerSize', Makersize, 'Marker', markerspec{1});         
h4 = plot(s2.Time , s2.Data,'Color',colorspec{3},'MarkerSize', Makersize, 'Marker', markerspec{2});         
h5 = plot(s3.Time , s3.Data,'Color',colorspec{4},'MarkerSize', Makersize, 'Marker', markerspec{3});         
xlim([0 3]); ylim([-1.4 4]);

hold on;
str = legend('reference', ...
             '$$C_1: S_1 = 10 [ms], \overline{e}$$ = 0.45 [radians]', ...
             '$$C_2: S_2 = 20 [ms], \overline{e}$$ = 0.62 [radians]', ...
             '$$C_3: S_3 = 40 [ms], \overline{e}$$ = 0.94 [radians]');
set(str,'Interpreter','latex','fontsize',10)


%%
[mean_e1, mean_e2, mean_e3]
fprintf('Done \n');


