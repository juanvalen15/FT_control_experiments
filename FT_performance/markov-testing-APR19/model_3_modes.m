%% Markov process model of Fault-Tolerant Switching Mechanism
%% clear all
clear all;
close all;
clc;

%% parameters
lambda_1 = 0.3;
lambda_2 = 0.3;
lambda_3 = 0.3;
mu = 0.99;

%%
span = 1:1:500; % TODO: define units
m0 = [0 0 0 1];
[t, m] = ode23(@(t,m) odeReliability(t, m, lambda_1, lambda_2, lambda_3, mu), span, m0);


%% plot
figure
plot(t, m(:,2), t, m(:,3), t, m(:,4), 'LineWidth',2)
grid on
xlabel('time [s]')
legend('mode(1)','mode(2)','mode(3)')
ylabel('probability')


%% differential equations
% function dmdt = odeReliability(t, m, lambda_1, lambda_2, lambda_3, mu)
%   dmdt = zeros(4,1);
%   dmdt(1) = 0;
%   dmdt(2) = -lambda_1*m(2) + mu*m(3) - (lambda_3)*m(4);
%   dmdt(3) = lambda_1*m(2) - (lambda_2+mu)*m(3) + mu*m(4);
%   dmdt(4) = lambda_2*m(2) + lambda_3*m(3);
% end

function dmdt = odeReliability(t, m, lambda_1, lambda_2, lambda_3, mu)
  dmdt = zeros(4,1);
  dmdt(1) = 0;
  dmdt(2) = -lambda_1*m(2) + mu*m(3) - (lambda_3)*m(4);
  dmdt(3) = lambda_1*m(2) - (lambda_2+mu)*m(3) + mu*m(4);
  dmdt(4) = lambda_2*m(2) + lambda_3*m(3);
end
