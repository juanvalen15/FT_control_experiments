% Reliability test
% miu = 1/(FM*tf) FM=f*FD/(3*k) FD=18300CFs f=0.6 k=5 tf=10^-6
%%
clc
clear all;
close all;

%% parameters
lambda = 0.03;
miu = 0.01;

%% ---------------- Reliability ----------------------------------------
span = 1:1:500; 
r0 = [0 0 0 1];
[t,r] = ode23(@(t,r) odeReliability(t,r,lambda,miu), span, r0);
System_Reliability = r(:,3)+r(:,4);

plot(t,r(:,2),t,r(:,3),t,r(:,4),t,System_Reliability,'LineWidth',2)
title('Reliability of TMR(1) model')
xlabel('t(s)')
legend('P(1)','P(2)','P(3)','System Reliability')
ylabel('Probability')



%% ---------------------------------------------------------------------
function dydt = odeReliability(t,r,lambda,miu)
    dydt = zeros(4,1);
    dydt(1) = 0;
    dydt(2) = 2*lambda*r(3);
    dydt(3) = 3*lambda*r(4)-2*lambda*r(3)-miu*r(3);
    dydt(4) = -3*lambda*r(4)+miu*r(3);
    
end





