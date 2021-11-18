%% Markov process model of Fault-Tolerant Switching Mechanism
%% clear all
clear all;
close all;
clc;

%% parameters
f = [1 1 1];

sr_array = [];
t_array = [];
for lambda_s = 0.1:0.2:0.9
    %lambda_s = 0.1;
    
    lambda_m1 = lambda_s^2;
    lambda_m2 = lambda_s^4;
    lambda_m3 = lambda_s^8;
    
    lambda_a1 = 1 - (1-lambda_m1)^f(1);
    lambda_a2 = 1 - (1-lambda_m2)^f(2);
    lambda_a3 = 1 - (1-lambda_m3)^f(3);
        
    %%
    span = 1:1:200; % TODO: define units
    m0 = [0 1 0 0 0];
    [t, m] = ode23(@(t,m) odeReliability(t, m, lambda_m1, lambda_m2, lambda_m3, lambda_a1, lambda_a2, lambda_a3), span, m0);
    system_reliability = m(:,2) + m(:,3) + m(:,4);
%     system_reliability = 1 - m(:,5);
    
    sr_array = [sr_array system_reliability];
    t_array = [t_array t];
end


%% plot
figure
plot(t, m(:,2), t, m(:,3), t, m(:,4), t, m(:,5), t, system_reliability, 'LineWidth',2)
grid on
xlabel('time [s]')
ylabel('probability')
legend('mode(1)','mode(2)','mode(3)', 'failure', 'reliability')

figure
plot(t_array, sr_array, 'LineWidth',2)
grid on
xlabel('time [s]')
ylabel('reliability probability')
legend('\lambda_s = 0.1', '\lambda_s = 0.3', '\lambda_s = 0.5', '\lambda_s = 0.7', '\lambda_s = 0.9')

%% differential equations
function dmdt = odeReliability(t, m, lambda_m1, lambda_m2, lambda_m3, lambda_a1, lambda_a2, lambda_a3)
dmdt = zeros(5,1);
dmdt(1) = 0;
dmdt(2) = -(lambda_m1 + lambda_a1)*m(2);
dmdt(3) = lambda_m1*m(2) - (lambda_m1 + lambda_a2)*m(3);
dmdt(4) = lambda_m2*m(3) - lambda_a3*m(4);
dmdt(5) = lambda_a1*m(2) + lambda_a2*m(3) + lambda_a3*m(4);
end

