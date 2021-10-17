% Simulation and CompSoC implementation results plots
clearvars -global; clearvars; close all; clc;

%% Color and line specs
colorspec   = { [0.9290 0.6940 0.1250]; ...
                [0.4660 0.6740 0.1880]; ...
                [0.8500 0.3250 0.0980]; ...
                [0.2 0.2 0.2]; ...
                [0 1 0]; ...
                [1 0 0]; ...
                [0 0 1]; ...
                [1 0 1]; ...
                [0 1 1]; ...
                [1 1 0]; ...
                [0.4940 0.1840 0.5560]; ...
                [0.8 0.1 0.1]; ...
                [0.1 0.5 0.3]; ...
                [0.1 0.6 0.9]; ...
                [0.78 0.13 0.34]; ...
                };  % colors for plotting ... up to ten.
markerspec  = {'o','+','*','.','x','s','d','^','v','>','<','p','h'};
markersize  = 4;



%%
% controllers 
% ctrl1 = single rate
% ctrl2 = fully lmi
% ctrl3 = lmi+pso
% ctrl4 = lqr-lptv


% experiments
% EXP =1 => 10/10 SLOTS
% EXP =2 => 5/10 SLOTS
% EXP =3 => 2/10 SLOTS
% EXP =4 => 1/10 SLOTS



for exp_index = 1:4        
    EXP = exp_index;
    main_exp;
    
    %% single-rate control simulation -----------------------------------------
    load(['output\results\exp' int2str(EXP) '\SR_PSO\C1-BEST.mat']); 
    data_compsoc_ctrl1 = csvread(['compsoc_output\app_platform_aware_exp' int2str(EXP) '_ctrl1.parsed']);
    x_compsoc_ctrl1{exp_index} = data_compsoc_ctrl1(:,2);
    K_temp{1} = K;
    F_temp{1} = F;
    DELAY_ON_OFF = 1;
    [x_ctrl1{exp_index}, u_ctrl1{exp_index}, time_ctrl1{exp_index}] = single_rate_script_based_simulation(PLOTS_SCRIPT_SIM_ON_OFF, DELAY_ON_OFF, SIM_TIME, SIM_REFERENCE, SP_baseline, A_aug_baseline, B_aug_baseline, K_temp, F_temp);    
    [~, length_sim_ctrl1{exp_index}]     = size(time_ctrl1{exp_index});
    [length_compsoc_ctrl1{exp_index}, ~] = size(x_compsoc_ctrl1{exp_index});    
    clear K F Q R Ts delay K_temp F_temp DELAY_ON_OFF;


    %% fully-lmi control simulation -------------------------------------------
    load(['output\results\exp' int2str(EXP) '\FULLY_LMI\SWITCHING_CONTROLLERS.mat']); 
    data_compsoc_ctrl2 = csvread(['compsoc_output\app_platform_aware_exp' int2str(EXP) '_ctrl2.parsed']);
    x_compsoc_ctrl2{exp_index} = data_compsoc_ctrl2(:,2);
    [x_ctrl2{exp_index}, u_ctrl2{exp_index}, time_ctrl2{exp_index}] = multi_rate_script_based_simulation(PLOTS_SCRIPT_SIM_ON_OFF, SIM_TIME, SIM_REFERENCE, all_h, s{1}, sp_sequence_s, A_aug, B_aug, K, F);
    [~, length_sim_ctrl2{exp_index}]	 = size(time_ctrl2{exp_index});
    [length_compsoc_ctrl2{exp_index}, ~] = size(x_compsoc_ctrl2{exp_index});    
    clear K F;

    %% lmi+pso control simulation ---------------------------------------------
    load(['output\results\exp' int2str(EXP) '\LMI_PSO\SWITCHING_CONTROLLERS.mat']); 
    data_compsoc_ctrl3 = csvread(['compsoc_output\app_platform_aware_exp' int2str(EXP) '_ctrl3.parsed']);
    x_compsoc_ctrl3{exp_index} = data_compsoc_ctrl3(:,2);    
    [x_ctrl3{exp_index}, u_ctrl3{exp_index}, time_ctrl3{exp_index}] = multi_rate_script_based_simulation(PLOTS_SCRIPT_SIM_ON_OFF, SIM_TIME, SIM_REFERENCE, all_h, s{1}, sp_sequence_s, A_aug, B_aug, K, F);
    [~, length_sim_ctrl3{exp_index}]     = size(time_ctrl3{exp_index});
    [length_compsoc_ctrl3{exp_index}, ~] = size(x_compsoc_ctrl3{exp_index});    
    clear K F;

    %% lqr-lptv control simulation --------------------------------------------
    load(['output\results\exp' int2str(EXP) '\LQR_LPTV\MATRICES_SIM_RESULTS.mat']); 
    data_compsoc_ctrl4 = csvread(['compsoc_output\app_platform_aware_exp' int2str(EXP) '_ctrl4.parsed']);
    x_compsoc_ctrl4{exp_index} = data_compsoc_ctrl4(:,2);    
    for i = 1:length(Ks)
        K{i}  = -Ks{i};
        Cs{i} = C_aug{1};
        F{i}  = inv( Cs{i} / ( eye(dim+1) - As{i} - (Bs{i}*K{i}) ) * Bs{i}); % feedforward gain            
    end
    [x_ctrl4{exp_index}, u_ctrl4{exp_index}, time_ctrl4{exp_index}] = multi_rate_script_based_simulation(PLOTS_SCRIPT_SIM_ON_OFF, SIM_TIME, SIM_REFERENCE, all_h, s{1}, sp_sequence_s, A_aug, B_aug, K, F);
    [~, length_sim_ctrl4{exp_index}]     = size(time_ctrl4{exp_index});
    [length_compsoc_ctrl4{exp_index}, ~] = size(x_compsoc_ctrl4{exp_index});    
    clear A_aug As B_aug Bs F K Ks Ss;
end




% %% plots
% close all;
% 
% %% single rate
% figure;
% for i = 1:4
%     subplot(2,2,i);
%     plot(time_ctrl1{i}(1,1:length_sim_ctrl1{i}),x_ctrl1{i}(1,2:length_sim_ctrl1{i}+1),'r-o','LineWidth', 2,'MarkerSize', 12); hold on;
%     plot(time_ctrl1{i}(1,1:length_sim_ctrl1{i}), x_compsoc_ctrl1{i}(1:length_sim_ctrl1{i}),'b:x','LineWidth', 2,'MarkerSize', 4);
%     grid on; legend('matlab','compsoc'); xlim([0 2]);
% end
% 
% 
% %% lmi + pso
% figure;
% for i = 1:4
%     subplot(2,2,i);
%     plot(time_ctrl3{i}(1,1:length_sim_ctrl3{i}),x_ctrl3{i}(1,2:length_sim_ctrl3{i}+1),'r-o','LineWidth', 2,'MarkerSize', 12); hold on;
%     plot(time_ctrl3{i}(1,1:length_sim_ctrl3{i}), x_compsoc_ctrl3{i}(1:length_sim_ctrl3{i}),'b:x','LineWidth', 2,'MarkerSize', 4);
%     grid on; legend('matlab','compsoc'); xlim([0 0.08]);
% end
% 
% %% lqr-lptv
% figure;
% min_length = [];
% for i = 1:4
%     subplot(2,2,i);
%     min_length(i) = min(length_compsoc_ctrl4{i}, length_sim_ctrl4{i});  
%     plot(time_ctrl4{i}(1,1:min_length(i)),x_ctrl4{i}(1,2:min_length(i)+1),'r-o','LineWidth', 2,'MarkerSize', 12); hold on;
%     plot(time_ctrl4{i}(1,1:min_length(i)),x_compsoc_ctrl4{i}(1:min_length(i)),'b:x','LineWidth', 2,'MarkerSize', 4);
%     if i <= 2
%         grid on; legend('matlab','compsoc'); xlim([0 0.03]);
%     else
%         grid on; legend('matlab','compsoc'); xlim([0 4]);
%     end
% end

%%
figure;

i = 1;

subplot(3,1,1);
min_length(i) = min(length_compsoc_ctrl4{i}, length_sim_ctrl4{i});  
plot(time_ctrl4{i}(1,1:min_length(i)),x_ctrl4{i}(1,2:min_length(i)+1),'r-o','LineWidth', 2,'MarkerSize', 12); hold on;
plot(time_ctrl4{i}(1,1:min_length(i)),x_compsoc_ctrl4{i}(1:min_length(i)),'b:x','LineWidth', 2,'MarkerSize', 4);
if i <= 2
    grid on; legend('MATLAB', 'HIL'); xlim([0 0.03]);
else
    grid on; legend('MATLAB', 'HIL'); xlim([0 4]);
end

subplot(3,1,2);
plot(time_ctrl3{i}(1,1:length_sim_ctrl3{i}),x_ctrl3{i}(1,2:length_sim_ctrl3{i}+1),'r-o','LineWidth', 2,'MarkerSize', 12); hold on;
plot(time_ctrl3{i}(1,1:length_sim_ctrl3{i}), x_compsoc_ctrl3{i}(1:length_sim_ctrl3{i}),'b:x','LineWidth', 2,'MarkerSize', 4);
grid on; legend('MATLAB', 'HIL'); xlim([0 0.08]);

subplot(3,1,3);
plot(time_ctrl1{i}(1,1:length_sim_ctrl1{i}),x_ctrl1{i}(1,2:length_sim_ctrl1{i}+1),'r-o','LineWidth', 2,'MarkerSize', 12); hold on;
plot(time_ctrl1{i}(1,1:length_sim_ctrl1{i}), x_compsoc_ctrl1{i}(1:length_sim_ctrl1{i}),'b:x','LineWidth', 2,'MarkerSize', 4);
grid on; legend('MATLAB', 'HIL'); xlim([0 2]);


%%
figure;
i = 1;
plot(time_ctrl3{i}(1,1:length_sim_ctrl3{i}),x_ctrl3{i}(1,2:length_sim_ctrl3{i}+1),'r-o','LineWidth', 2,'MarkerSize', 12); hold on;
plot(time_ctrl3{i}(1,1:length_sim_ctrl3{i}), x_compsoc_ctrl3{i}(1:length_sim_ctrl3{i}),'b:x','LineWidth', 2,'MarkerSize', 4);
xlabel('time [s]');
ylabel('system output y_k [rad]');
xticks([0 0.01 0.02 0.03 0.04]);
xlim([0 0.04]);
legend('y^{MATLAB}_k', 'y^{HIL}_k'); 
grid on; 
grid minor;




%% errors
max_error_sr = [];
max_error_fully_lmi = [];
max_error_lmi_pso = [];
max_error_lqr_lptv = [];

perc_error_sr = [];
perc_error_fully_lmi = [];
perc_error_lmi_pso = [];
perc_error_lqr_lptv = [];

for i = 1:4
    matx_sr{i} = time_ctrl1{i}(1,1:length_sim_ctrl1{i}); 
    maty_sr{i} = x_ctrl1{i}(1,2:length_sim_ctrl1{i}+1);
    comx_sr{i} = time_ctrl1{i}(1,1:length_sim_ctrl1{i}); 
    comy_sr{i} = x_compsoc_ctrl1{i}(1:length_sim_ctrl1{i});    
    error_sr{i} = abs((maty_sr{i})' - comy_sr{i}); 
    max_error_sr(i) = max(error_sr{i});
    perc_error_sr(i) = max( (error_sr{i}./(maty_sr{i})') * 100);
    
    matx_fully_lmi{i} = time_ctrl2{i}(1,1:length_sim_ctrl2{i}); 
    maty_fully_lmi{i} = x_ctrl2{i}(1,2:length_sim_ctrl2{i}+1);
    comx_fully_lmi{i} = time_ctrl2{i}(1,1:length_sim_ctrl2{i}); 
    comy_fully_lmi{i} = x_compsoc_ctrl2{i}(1:length_sim_ctrl2{i});    
    error_fully_lmi{i} = abs((maty_fully_lmi{i})' - comy_fully_lmi{i});                
    max_error_fully_lmi(i) = max(error_fully_lmi{i});
    perc_error_fully_lmi(i) = max( (error_fully_lmi{i}./(maty_fully_lmi{i})') * 100);
 
    matx_lmi_pso{i} = time_ctrl3{i}(1,1:length_sim_ctrl3{i}); 
    maty_lmi_pso{i} = x_ctrl3{i}(1,2:length_sim_ctrl3{i}+1);
    comx_lmi_pso{i} = time_ctrl3{i}(1,1:length_sim_ctrl3{i}); 
    comy_lmi_pso{i} = x_compsoc_ctrl3{i}(1:length_sim_ctrl3{i});    
    error_lmi_pso{i} = abs((maty_lmi_pso{i})' - comy_lmi_pso{i});                
    max_error_lmi_pso(i) = max(error_lmi_pso{i});
    perc_error_lmi_pso(i) = max( (error_lmi_pso{i}./(maty_lmi_pso{i})') * 100);
    
    min_length_lqr_lptv(i) = min(length_compsoc_ctrl4{i}, length_sim_ctrl4{i});  
    matx_lqr_lptv{i} = time_ctrl4{i}(1,min_length_lqr_lptv(i)); 
    maty_lqr_lptv{i} = x_ctrl4{i}(1,2:min_length_lqr_lptv(i)+1);
    comx_lqr_lptv{i} = time_ctrl4{i}(1,1:min_length_lqr_lptv(i)); 
    comy_lqr_lptv{i} = x_compsoc_ctrl4{i}(1:min_length_lqr_lptv(i));    
    error_lqr_lptv{i} = abs((maty_lqr_lptv{i})' - comy_lqr_lptv{i});                        
    max_error_lqr_lptv(i) = max(error_lqr_lptv{i});
    perc_error_lqr_lptv(i) = max( (error_lqr_lptv{i}./(maty_lqr_lptv{i})') * 100);
end


%% Error plots
%resources
C = 4096;    % [clock cycles @ F]
P = 2995904;  % [clock cycles @ F]
resources(1) = (10/10) * (P/(P+C)) * 100;
resources(2) = (5/10) * (P/(P+C)) * 100;
resources(3) = (2/10) * (P/(P+C)) * 100;
resources(4) = (1/10) * (P/(P+C)) * 100;


figure;
semilogy(resources, [0.05 0.05 0.05 0.05], 'Color',colorspec{1}, 'MarkerSize', 8, 'Marker', markerspec{1},'LineWidth',2); hold on;
semilogy(resources, max_error_sr, 'Color',colorspec{2}, 'MarkerSize', 8, 'Marker', markerspec{1},'LineWidth',2); hold on;
semilogy(resources, max_error_lmi_pso, 'Color',colorspec{3}, 'MarkerSize', 8, 'Marker', markerspec{3},'LineWidth',2); hold on;
semilogy(resources, max_error_lqr_lptv, 'Color',colorspec{4}, 'MarkerSize', 8, 'Marker', markerspec{5},'LineWidth',2); hold on;
grid on;
grid minor;
xlabel('U(\lambda_C) %');
ylabel('max. absolute error max(|y^{MATLAB}_k - y^{HIL}_k|) [rad]');
legend('r', 'SR', 'MRLO', 'MRGO','Location', 'northeast');




