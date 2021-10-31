% comparisons with state of the art
clear all
close all
clc


%% faults list
F     = 0:1:10;
Y.w2  = (2*F)+1;

for i = 1:length(F)    
    j=1;
    if( F(i) <= 2^(j+1)-2 )
        Y.our(i) = 2^(j+1);
        m.our(i) = j;
    else
        while( F(i) > 2^(j+1)-2 )
            j=j+1;
        end
        Y.our(i) = 2^(j+1);
        m.our(i) = j;
    end    
end


%% timing properties [our work]
omega = 1;
psi   = 5*omega;
hm    = 5*(psi+omega);


lambda = 1e-05; % reliablity consideration

for i = 1:length(m.our)
    T(i) = 2^(i+1) * hm;
    
    C(i) = 4*omega;
    D(i) = (2^(i+1) - 1)*hm + C(i);
    
    
    U.our(i) = C(i)*Y.our(i)/T(i);
    U.w2(i)  = C(i)*Y.w2(i)/T(i);

end



%% printing parameters
table(F', m.our', Y.our', Y.w2', C', T', D', U.our', U.w2', ... 
      'VariableNames', ...
      {'F', 'm', 'Y.our', 'Y.w2', 'Ci.our', 'T.our', 'D.our', 'U.our', 'U.w2'})



  
%% plots

figure;
hold on;
plot(F,Y.w2,'-mo','MarkerSize',8); 
plot(F,Y.our,'-bo','MarkerSize',8);
hold off;
grid on;
grid minor;
xlabel('Faults');
ylabel('Redundancy [executions]');
legend('R - Zhou2016', 'R - Our Approach');

figure;
hold on;
plot(F,U.w2,'-go','MarkerSize',8);
plot(F,U.our,'-ro','MarkerSize',8);
hold off;
grid on; 
grid minor;
xlabel('Faults');
ylabel('Utilisation');
legend('U - Zhour2016','U - Our Approach');


[mean(U.our(3:end)) mean(U.w2(3:end)) mean(Y.our(1:end)) mean(Y.w2(1:end))]


%% Task set T
% C = C.our(2:end);
% T = T.our(2:end);
% D = D.our(2:end);
% L = ones(1,length(C));
% L(1) = 0; % task for f=0 is LO
% Y.w2  = Y.w2(2:end); % yi_w2 = 2*Ni+1 = 5 is for N=2
% Y.our = Y.our(2:end); % y1_our = 2^(i+1) = 4 for N=2 | in our case Y=1 is also valid as we only consider our approach for i >= 1. i =0 is just the app running without redundancy
% 
% % From task set
% length_T = length(L);
% H = elcm(T); % lcm of T

% %% Reliability + Utilisation calculation
% U.w2.LO = 0;
% U.w2.HI = 0;
% U.our.LO = 0;
% U.our.HI = 0;
% 
% for i = 1:length_T    
%     if L(i)==0 % LO
%         R.w2(i)  = exp(-lambda*C(i));
%         R.our(i) = exp(-lambda*C(i));
%         U.w2.LO = U.w2.LO + ( C(i)*Y.w2(i)/T(i) );
%         U.our.LO = U.our.LO + ( C(i)*Y.our(i)/T(i) );
%     elseif L(i)==1 % HI
%         R.w2(i)  = 1 - (1 - exp(-lambda*C(i)))^Y.w2(i);
%         R.our(i) = 1 - (1 - exp(-lambda*C(i)))^Y.our(i);
%         U.w2.HI = U.w2.HI + ( C(i)*Y.w2(i)/T(i) );
%         U.our.HI = U.our.HI + ( C(i)*Y.our(i)/T(i) );
%     else
%         error('wrong priority');
%     end
% end
% 
% U.w2  = U.w2.LO + U.w2.HI;
% U.our = U.our.LO + U.our.HI;
% 
% U
