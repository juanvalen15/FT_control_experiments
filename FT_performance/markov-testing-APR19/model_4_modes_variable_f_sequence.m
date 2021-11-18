%% Markov process model of Fault-Tolerant Switching Mechanism
%% clear all
clear all;
close all;
clc;

%% parameters
%--------------
fsw{1} = [1 1 1];
fsw{2} = [4 4 4];
%--------------

SIM_TIME = 200;

sr_bl_array  = [];
sr_fsw_array = [];
t_fsw_array  = [];

for i = 1:length(fsw)
    f = fsw{i}; % switching sequence f
    
    sr_bl = [];
    sr_array = [];
    t_array = [];
    system_reliability = [];
    
    for lambda_s = [0.1 0.5 0.9]
        lambda_m1 = lambda_s^2;
        lambda_m2 = lambda_s^4;
        lambda_m3 = lambda_s^8;
        
        lambda_a1 = 1 - (1-lambda_m1)^f(1);
        lambda_a2 = 1 - (1-lambda_m2)^f(2);
        lambda_a3 = 1 - (1-lambda_m3)^f(3);
        
        %%
        span = 1:1:SIM_TIME;
        m0   = [0 1 0 0 0];
        m0_BL = [0 1 0];
        
        [t, m] = ode23(@(t,m) odeReliability(t, m, lambda_m1, lambda_m2, lambda_m3, lambda_a1, lambda_a2, lambda_a3), span, m0);
        [tBL, mBL] = ode23(@(tBL,mBL) odeBL(tBL, mBL, lambda_a3), span, m0_BL);
                
        system_reliability = 1 - m(:,5); % R(t) = 1 - prob_mode4
        system_reliability_bl = 1 - mBL(:,3); % R(t) = 1 - prob_mode4
        
        sr_bl = [sr_bl system_reliability_bl];
        sr_array = [sr_array system_reliability];
        t_array  = [t_array t];
        
        sr_bl_array{i}  = sr_bl;
        sr_fsw_array{i} = sr_array;
        t_fsw_array{i}  = t_array;
    end
end

%% plot
%%
figure;
subplot(1,3,1);
plot(t_fsw_array{1}(:,1), sr_fsw_array{1}(:,1), 'r*-', 'LineWidth', 2); hold on;
plot(t_fsw_array{2}(:,1), sr_fsw_array{2}(:,1), 'go-', 'LineWidth', 2); hold on;
plot(t_fsw_array{1}(:,1), sr_bl_array{1}(:,1), 'b-.', 'LineWidth', 2); hold on;
ylim([0 1]);

grid on;
title('\lambda_s = 0.1');
xlabel('time [s]');
ylabel('reliability probability');
legend('f = [1 1 1]','f = [4 4 4]', 'no redundancy');

%-
subplot(1,3,2);
plot(t_fsw_array{1}(:,1), sr_fsw_array{1}(:,2), 'r*-', 'LineWidth', 2); hold on;
plot(t_fsw_array{2}(:,1), sr_fsw_array{2}(:,2), 'go-', 'LineWidth', 2); hold on;
plot(t_fsw_array{1}(:,1), sr_bl_array{1}(:,2), 'b-.', 'LineWidth', 2); hold on;
ylim([0 1]);

grid on;
title('\lambda_s = 0.5');
xlabel('time [s]');
ylabel('reliability probability');
legend('f = [1 1 1]','f = [4 4 4]', 'no redundancy');

%-
subplot(1,3,3);
plot(t_fsw_array{1}(:,1), sr_fsw_array{1}(:,3), 'r*-', 'LineWidth', 2); hold on;
plot(t_fsw_array{2}(:,1), sr_fsw_array{2}(:,3), 'go-', 'LineWidth', 2); hold on;
plot(t_fsw_array{1}(:,1), sr_bl_array{1}(:,3), 'b-.', 'LineWidth', 2); hold on;
ylim([0 1]);

grid on;
title('\lambda_s = 0.9');
xlabel('time [s]');
ylabel('reliability probability');
legend('f = [1 1 1]','f = [4 4 4]', 'no redundancy');

%% differential equations
function dmdt = odeReliability(t, m, lambda_m1, lambda_m2, lambda_m3, lambda_a1, lambda_a2, lambda_a3)
dmdt = zeros(5,1);
dmdt(1) = 0;
dmdt(2) = -(lambda_m1 + lambda_a1)*m(2);
dmdt(3) = lambda_m1*m(2) - (lambda_m2 + lambda_a2)*m(3);
dmdt(4) = lambda_m2*m(3) - lambda_a3*m(4);
dmdt(5) = lambda_a1*m(2) + lambda_a2*m(3) + lambda_a3*m(4);
end

function dmdt = odeBL(tBL, mBL, lambda_a3)
dmdt = zeros(3,1);
dmdt(1) = 0;
dmdt(2) = -lambda_a3*mBL(2);
dmdt(3) = lambda_a3*mBL(2);
end
