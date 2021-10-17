% Comparison of reference works with proposed fault-tolerant mechanism

%% clear all
clear all;
close all;
clc;

%% loading files
load sim_ft_2faults_1s.mat;
tSW = sensed_data_x1.Time(1:201);
zSW = [sensed_data_x1.Data(1:201)'; sensed_data_x2.Data(1:201)'; sensed_data_x3.Data(1:201)'; sensed_data_x4.Data(1:201)'];
SS_SW = stepinfo(zSW(1,:), tSW);

load sim_W1_ref_results;
tW1 = time_vector;
zW1 = zkp1;
SS_W1 = stepinfo(zW1(1,:), tW1);

load sim_W3_ref_results;
tW3 = time_vector;
zW3 = zkp1;
SS_W3 = stepinfo(zW3(1,:), tW3);


%% plots

figure; 
% subplot(3,2,1);
plot(tW1, zW1(1,:), '-', ...
     tW3, zW3(1,:), '-', ...
     tSW, zSW(1,:), '-', ...
     'linewidth', 3, ...
     'markersize', 16);
xlabel('time [s]'); ylabel('\theta_1 [rad]');

xlim([0 1]);
grid on;
grid minor;
legend(['W1 settling time= ' num2str(SS_W1.SettlingTime) ' s | QoC= ' num2str(1/SS_W1.SettlingTime)], ...
       ['W3 settling time= ' num2str(SS_W3.SettlingTime) ' s | QoC= ' num2str(1/SS_W3.SettlingTime)], ...
       ['SW settling time= ' num2str(SS_SW.SettlingTime) ' s | QoC= ' num2str(1/SS_SW.SettlingTime)]);


% subplot(3,2,2);
% x1_drop   = zkp1(1,:);
% x1_switch = sensed_data_x1.Data(1:201);
% plot(time_vector, abs(x1_switch(1:2:end) - x1_drop'), ':.');
% xlabel('time [s]'); ylabel('abs. error \theta_1 [rad]');
% grid on;
% grid minor;
% legend('|PD-SM|');
% 
% subplot(3,2,3);
% plot(time_vector,zkp1(3,:), ':.', ...
%      sensed_data_x3.Time(1:201), sensed_data_x3.Data(1:201), ':.');
% xlabel('time [s]'); ylabel('\omega_1 [rad/s]');
% grid on;
% grid minor;
% legend('PD', 'SM');
% 
% subplot(3,2,4);
% x3_drop   = zkp1(3,:);
% x3_switch = sensed_data_x3.Data(1:201);
% plot(time_vector, abs(x3_switch(1:2:end) - x3_drop'), ':.');
% xlabel('time [s]'); ylabel('abs. error \omega_1 [rad/s]');
% grid on;
% grid minor;
% legend('|PD-SM|');
% 
% subplot(3,2,5);
% plot(time_vector,zkp1(5,:), ':.', ...
%      actuation_signal_u.Time(1:201), actuation_signal_u.Data(1:201), ':.');
% xlabel('time [s]'); ylabel('u [A]');
% grid on;
% grid minor;
% legend('PD', 'SM');
% 
% subplot(3,2,6);
% u_drop   = zkp1(5,:);
% u_switch = actuation_signal_u.Data(1:201);
% plot(time_vector, abs(u_switch(1:2:end) - u_drop'), ':.');
% xlabel('time [s]'); ylabel('abs. error u [A]');
% grid on;
% grid minor;
% legend('|PD-SM|');