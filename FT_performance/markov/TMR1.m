%Reliability level, availability, and performance overhead calculation for
%simple TMR system with and without reconfiguration.

%miu = 1/(FM*tf) FM=f*FD/(3*k) FD=18300CFs f=0.6 k=5 tf=10^-6
clc
clear;

tf=10^-6;
FM = 0.6*18300/(3*5);

im=0;

if(im==0)
    lambda = 0.03;
    miu = 0.01;
    %syms lambda miu
else
    lambda = 1/(1.5*60*60);
    miu = 1/(FM*tf); %*10^7
end


%---------------- Reliability ----------------------------------------
span = 1:1:500; 
r0 = [0 0 0 1];
[t,r] = ode23(@(t,r) odeReliability(t,r,lambda,miu), span, r0);
System_Reliability = r(:,3)+r(:,4);

plot(t,r(:,2),t,r(:,3),t,r(:,4),t,System_Reliability,'LineWidth',2)
title('Reliability of TMR(1) model')
xlabel('t(s)')
legend('P(1)','P(2)','P(3)','System Reliability')
ylabel('Probability')


%---------------- Availability ----------------------------------------
span = 1:1:500; 
a0 = [0 0 0 1];
[t,a] = ode23(@(t,a) odeAvailability(t,a,lambda,miu), span, a0);
System_Availability = a(:,3)+a(:,4);
figure
plot(t,a(:,2),t,a(:,3),t,a(:,4),t,System_Availability,'LineWidth',2)
title('Availability of TMR(1) model')
xlabel('t(s)')
legend('P(1)','P(2)','P(3)','System Availability')
ylabel('Probability')

%----------------------------------------------------------------------
%---------------- Performance overhead --------------------------------

sweep=500;
mission_duration = 2:1:sweep;
T_fault=mission_duration*lambda;

i1=(1+(a(mission_duration,3)./a(mission_duration,2))).^(-1).*(T_fault.');
i2=i1.*(a(mission_duration,3)./a(mission_duration,2));

p1=i1.*(miu/2)^(-1);
p2=i2.*miu^(-1);

T_p=p1+p2;
figure
plot(mission_duration,T_p,'LineWidth',2)
title('Performance overhead TMR(1)')
xlabel('mission duration')
ylabel('Performance overhead')


fileID = fopen('TMR1.txt','w');
for i=1:1:size(r,1)
    if(i==1)
        fprintf(fileID,'Reliability\t Availability\t Performance ovrehaed\n');
    end
    fprintf(fileID,'%f\t',System_Reliability(i));
    fprintf(fileID,'%f\t',System_Availability(i));
    if(i~=size(r,1))
        fprintf(fileID,'%f\n',T_p(i,1));
    end
end
fclose(fileID);
%---------------------------------------------------------------------
%---------------------------------------------------------------------
%---------------------------------------------------------------------
function dydt = odeReliability(t,r,lambda,miu)
    dydt = zeros(4,1);
    dydt(1) = 0;
    dydt(2) = 2*lambda*r(3);
    dydt(3) = 3*lambda*r(4)-2*lambda*r(3)-miu*r(3);
    dydt(4) = -3*lambda*r(4)+miu*r(3);
    
end

function dydt = odeAvailability(t,a,lambda,miu)
    dydt = zeros(4,1);
    dydt(1) = 0;
    dydt(2) = 2*lambda*a(3)-(miu/2)*a(2);
    dydt(3) = 3*lambda*a(4)-2*lambda*a(3)-miu*a(3)+(miu/2)*a(2);
    dydt(4) = -3*lambda*a(4)+miu*a(3);
end











%%---------------------------------------------------------------------
%%---------------------------------------------------------------------
%%---------------- Reliability ----------------------------------------
% syms r3(t) r2(t) r1(t);
% y3 = diff(r3,t)==-3*lambda*r3+miu*r2;
% y2 = diff(r2,t)==3*lambda*r3-2*lambda*r2-miu*r2;
% y1 = diff(r1,t)==2*lambda*r2;
% 
% odes=[y1,y2,y3];
% cond = [r3(0)==1,r2(0)==0,r1(0)==0];
% 
% [R1Sol(t), R2Sol(t),R3Sol(t)]=dsolve(odes,cond);
% 
% y3=subs(R1Sol(t)+R2Sol(t)+R3Sol(t)==1);
% R1Sol=subs(R1Sol,lhs(y3),rhs(y3));
% R2Sol=subs(R2Sol,lhs(y3),rhs(y3));
% R3Sol=subs(R3Sol,lhs(y3),rhs(y3));
% TMR_Reliability = R3Sol+R2Sol;
% 
% disp('P1(t):')
% disp(R1Sol(t));
% disp('P2(t):')
% disp(R2Sol(t));
% disp('P3(t):')
% disp(R3Sol(t));
% disp('Reliability of TMR:')
% disp(TMR_Reliability);
% 
% if(im==0)
%     t1 = 0:10^1:10^3;
%     t1=t1';
%     z1=eval(subs(R1Sol,t,t1));
%     plot(t1,z1,'LineWidth',2)
%     hold on
% 
%     z2=eval(subs(R2Sol,t,t1));
%     plot(t1,z2,'LineWidth',2)
% 
%     z3=eval(subs(R3Sol,t,t1));
%     plot(t1,z3,'LineWidth',2)
% 
%     z4=eval(subs(TMR_Reliability,t,t1));
%     plot(t1,z4,'LineWidth',2)
% 
%     title('Markov cahin model');
%     xlabel('t[s]') % x-axis label
%     ylabel('Probability') % y-axis label
%     legend('P1(t)','P2(t)','P3(t)','Reliability(t)')
%     hold off   
% else
%     t1 = 0:10^6:10^10;
%     t1=t1';
%     z1=eval(subs(R1Sol,t,t1));
%     plot(t1/(365*24*60*60),z1,'LineWidth',2)
%     hold on
% 
%     z2=eval(subs(R2Sol,t,t1));
%     plot(t1/(365*24*60*60),z2,'LineWidth',2)
% 
%     z3=eval(subs(R3Sol,t,t1));
%     plot(t1/(365*24*60*60),z3,'LineWidth',2)
% 
%     z4=eval(subs(TMR_Reliability,t,t1));
%     plot(t1/(365*24*60*60),z4,'LineWidth',2)
% 
%     title('Markov cahin model');
%     xlabel('t[yrs]') % x-axis label
%     ylabel('Probability') % y-axis label
%     legend('P1(t)','P2(t)','P3(t)','Reliability(t)')
%     hold off
% end
% 
% %---------------------------------------------------------------------
% %---------------- Availaility ----------------------------------------
% syms a3(t) a2(t) a1(t);
% x3 = diff(a3,t)==-3*lambda*a3+miu*a2;
% x2 = diff(a2,t)==3*lambda*a3-2*lambda*a2-miu*a2+miu/2*a1;
% x1 = diff(a1,t)==2*lambda*a2-miu/2*a1;
% 
% odes=[x1,x2,x3];
% cond = [a3(0)==1,a2(0)==0,a1(0)==0];
% 
% [A1Sol(t), A2Sol(t),A3Sol(t)]=dsolve(odes,cond);
% 
% x3=subs(A1Sol(t)+A2Sol(t)+A3Sol(t)==1);
% A1Sol=subs(A1Sol,lhs(x3),rhs(x3));
% A2Sol=subs(A2Sol,lhs(x3),rhs(x3));
% A3Sol=subs(A3Sol,lhs(x3),rhs(x3));
% A4Sol=A2Sol+A3Sol;
% 
% disp('A1(t):')
% disp(A1Sol(t));
% disp('A2(t):')
% disp(A2Sol(t));
% disp('A3(t):')
% disp(A3Sol(t));
% 
% if(im==0)
%     t1 = 0:10^1:10^3;
%     t1=t1';
%     
%     figure
%     z1=eval(subs(A1Sol,t,t1));
%     plot(t1,z1,'LineWidth',2)
%     hold on
%     z2=eval(subs(A2Sol,t,t1));
%     plot(t1,z2,'LineWidth',2)
%     
%     z3=eval(subs(A3Sol,t,t1));
%     plot(t1,z3,'LineWidth',2)
%     
%     z4=eval(subs(A4Sol,t,t1));
%     plot(t1,z4,'LineWidth',2)
%     
%     title('Markov cahin model');
%     xlabel('t[s]') % x-axis label
%     ylabel('Probability') % y-axis label
%     legend('P1(t)','P2(t)','P3(t)','Availability(t)')
%     hold off
% else
%     t1 = 0:10^2:10^6;
%     t1=t1';
%     figure
%     z1=eval(subs(A1Sol,t,t1));
%     plot(t1/(365*24*60*60),z1,'LineWidth',2)
%     hold on
%     z2=eval(subs(A2Sol,t,t1));
%     plot(t1/(365*24*60*60),z2,'LineWidth',2)
%     
%     z3=eval(subs(A3Sol,t,t1));
%     plot(t1/(365*24*60*60),z3,'LineWidth',2)
%     
%     z4=eval(subs(A4Sol,t,t1));
%     plot(t1/(365*24*60*60),z4,'LineWidth',2)
%     
%     title('Markov cahin model');
%     xlabel('t[yrs]') % x-axis label
%     ylabel('Probability') % y-axis label
%     legend('P1(t)','P2(t)','P3(t)','Availability(t)')
%     hold off
% end
% 
% disp('Steady State Availability of A1:') 
% eval(A1Sol(inf));
% disp('Steady State Availability of A2:') 
% eval(A2Sol(inf));
% disp('Steady State Availability of A3:') 
% eval(A3Sol(inf));
%---------------------------------------------------------------------
%---------------------------------------------------------------------
