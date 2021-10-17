%% Markov process model of Fault-Tolerant Switching Mechanism
%% clear all
clear all;
close all;
clc;

%% parameters
%----------------------------
fsw{1} = [1 1 1 1 1 1 1 1 1 1];
fsw{2} = [4 4 4 4 4 4 4 4 4 4];
%----------------------------

SIM_TIME = 200;

sr_N1_ARRAY   = [];
sr_N3_ARRAY   = [];
sr_N10_ARRAY  = [];

for i = 1:length(fsw)
    %%
    f = fsw{i}; % switching sequence f
    
    sr_N1   = [];
    sr_N3   = [];
    sr_N10  = [];       
    
    for lambda_s = [0.2 0.5 0.9]
        %%
        lambda_m1 = lambda_s^2;
        lambda_m2 = lambda_s^4;
        lambda_m3 = lambda_s^8;
        lambda_m4 = lambda_s^16;
        lambda_m5 = lambda_s^32;
        lambda_m6 = lambda_s^64;
        lambda_m7 = lambda_s^128;
        lambda_m8 = lambda_s^256;
        lambda_m9 = lambda_s^512;
        lambda_m10 = lambda_s^1024;
        
        
        lambda_a1 = 1 - (1-lambda_m1)^f(1);
        lambda_a2 = 1 - (1-lambda_m2)^f(2);
        lambda_a3 = 1 - (1-lambda_m3)^f(3);
        lambda_a4 = 1 - (1-lambda_m4)^f(4);
        lambda_a5 = 1 - (1-lambda_m5)^f(5);
        lambda_a6 = 1 - (1-lambda_m6)^f(6);
        lambda_a7 = 1 - (1-lambda_m7)^f(7);
        lambda_a8 = 1 - (1-lambda_m8)^f(8);
        lambda_a9 = 1 - (1-lambda_m9)^f(9);        
        lambda_a10 = 1 - (1-lambda_m10)^f(10);
        
        %%
        span = 1:1:SIM_TIME;
        
        m0_N1  = [0 1 0];
        m0_N3  = [0 1 0 0 0];
        m0_N10 = [0 1 0 0 0 0 0 0 0 0 0 0];
        
        % n=1
        [t, mN1]   = ode23(@(t,m) odeN1(t, m, lambda_a1), span, m0_N1);
        % n=3
        [t, mN3]   = ode23(@(t,m) odeN3(t, m, lambda_m1, lambda_m2, lambda_m3, lambda_a1, lambda_a2, lambda_a3), span, m0_N3);
        % n=10
        [t, mN10] = ode23(@(t,m) odeN10(t, m, ...
                        lambda_m1, lambda_m2, lambda_m3, lambda_m4, lambda_m5, lambda_m6, lambda_m7, lambda_m8, lambda_m9, lambda_m10, ...
                        lambda_a1, lambda_a2, lambda_a3, lambda_a4, lambda_a5, lambda_a6, lambda_a7, lambda_a8, lambda_a9, lambda_a10), ...
                        span, m0_N10);
                        
        system_reliability_N1   = 1 - mN1(:,3);   % R(t) = 1 - prob_mode3 (FAIL)
        system_reliability_N3   = 1 - mN3(:,5);   % R(t) = 1 - prob_mode5 (FAIL)
        system_reliability_N10  = 1 - mN10(:,12);   % R(t) = 1 - prob_mode12 (FAIL)
        
        
        sr_N1    = [sr_N1 system_reliability_N1];
        sr_N3    = [sr_N3 system_reliability_N3];
        sr_N10   = [sr_N10 system_reliability_N10];        
        
        sr_N1_ARRAY{i}   = sr_N1;
        sr_N3_ARRAY{i}   = sr_N3;
        sr_N10_ARRAY{i}  = sr_N10;
    end
end


 
%% plot
%%
figure;
subplot(1,3,1);
plot(t, sr_N1_ARRAY{1}(:,1), 'r*-', 'LineWidth', 2); hold on;
plot(t, sr_N1_ARRAY{2}(:,1), 'go-', 'LineWidth', 2); hold on;
ylim([0 1]);

grid on;
title('n = 1');
xlabel('time [s]');
ylabel('reliability probability');
legend('f = [1]', 'f = [4]');

%-
subplot(1,3,2);
plot(t, sr_N3_ARRAY{1}(:,1), 'r*-', 'LineWidth', 2); hold on;
plot(t, sr_N3_ARRAY{2}(:,1), 'go-', 'LineWidth', 2); hold on;
ylim([0 1]);

grid on;
title('n = 3');
xlabel('time [s]');
ylabel('reliability probability');
legend('f = [1 1 1]', 'f = [4 4 4]');

%-
subplot(1,3,3);
plot(t, sr_N10_ARRAY{1}(:,1), 'r*-', 'LineWidth', 2); hold on;
plot(t, sr_N10_ARRAY{2}(:,1), 'go-', 'LineWidth', 2); hold on;
ylim([0 1]);

grid on;
title('n = 10');
xlabel('time [s]');
ylabel('reliability probability');
legend('f = [1 1 1 1 1 1 1 1 1 1]', 'f = [4 4 4 4 4 4 4 4 4 4]');














%% differential equations
function dmdt = odeN1(t, m, lambda_a1)
dmdt = zeros(3,1);
dmdt(1) = 0;
dmdt(2) = -lambda_a1*m(2);
dmdt(3) = lambda_a1*m(2);
end

function dmdt = odeN3(t, m, lambda_m1, lambda_m2, lambda_m3, lambda_a1, lambda_a2, lambda_a3)
dmdt = zeros(5,1);
dmdt(1) = 0;
dmdt(2) = -(lambda_m1 + lambda_a1)*m(2);
dmdt(3) = lambda_m1*m(2) - (lambda_m1 + lambda_a2)*m(3);
dmdt(4) = lambda_m2*m(3) - lambda_a3*m(4);
dmdt(5) = lambda_a1*m(2) + lambda_a2*m(3) + lambda_a3*m(4);
end

% function dmdt = odeN3(t, m, lambda_m1, lambda_m2, lambda_m3, lambda_a1, lambda_a2, lambda_a3)
% dmdt = zeros(5,1);
% dmdt(1) = 0;
% dmdt(2) = (1-lambda_a1-lambda_m1)*m(2) + (1-lambda_a2-lambda_m2)*m(3);
% dmdt(3) = lambda_m1*m(2) - (lambda_m2 + 1)*m(3) + (1-lambda_a3)*m(4);
% dmdt(4) = lambda_m2*m(3) - m(4);
% dmdt(5) = lambda_a1*m(2) + lambda_a2*m(3) + lambda_a3*m(4);
% end

function dmdt = odeN10(t, m, ...
        lambda_m1, lambda_m2, lambda_m3, lambda_m4, lambda_m5, lambda_m6, lambda_m7, lambda_m8, lambda_m9, lambda_m10, ...
        lambda_a1, lambda_a2, lambda_a3, lambda_a4, lambda_a5, lambda_a6, lambda_a7, lambda_a8, lambda_a9, lambda_a10)
dmdt = zeros(12,1);
dmdt(1) = 0;
dmdt(2) = -(lambda_m1 + lambda_a1)*m(2);
dmdt(3) = lambda_m1*m(2) - (lambda_m2 + lambda_a2)*m(3);
dmdt(4) = lambda_m2*m(3) - (lambda_m3 + lambda_a3)*m(4);  
dmdt(5) = lambda_m3*m(4) - (lambda_m4 + lambda_a4)*m(5);  
dmdt(6) = lambda_m4*m(5) - (lambda_m5 + lambda_a5)*m(6);  
dmdt(7) = lambda_m5*m(6) - (lambda_m6 + lambda_a6)*m(7);  
dmdt(8) = lambda_m6*m(7) - (lambda_m7 + lambda_a7)*m(8);  
dmdt(9) = lambda_m7*m(8) - (lambda_m8 + lambda_a8)*m(9);  
dmdt(10) = lambda_m8*m(9) - (lambda_m9 + lambda_a9)*m(10);  
dmdt(11) = lambda_m9*m(10) - lambda_a10*m(11);  
dmdt(12) = lambda_a1*m(2) + lambda_a2*m(3) + lambda_a3*m(4) + ...
           lambda_a4*m(5) + lambda_a5*m(6) + lambda_a6*m(7) + ...
           lambda_a7*m(8) + lambda_a8*m(9) + lambda_a9*m(10) + lambda_a10*m(11);
end


