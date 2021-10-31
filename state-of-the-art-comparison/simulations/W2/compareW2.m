    % comparisons with state of the art
clear all
close all
clc


%% input
Y.w2   = 3; % re-execution w2
Y.our  = 4; % re-execution our
lambda = 1e-05; % reliablity consideration

%% task set
Phi = 0.7;
Rhi = 4;
C_lo_max = 10;
T_max = 50;

set = random_task_generator(Phi,Rhi,C_lo_max,T_max);

%% Reliability calculation

M = 1; % # ratio of instances that finish execution in time 1/1

for i = 1:length(set)
    
    H = elcm(set(i).T);   
    
    for j = 1:2 % 2 tasks only    
        % reliablity
        if set(i).L(j)==0 % LO
            set(i).R_w2(j)  = exp(-lambda*set(i).C(j));
            set(i).R_our(j) = exp(-lambda*set(i).C(j));
        elseif set(i).L(j)==1 % HI  
            set(i).R_w2(j)  = 1 - (1 - exp(-lambda*set(i).C(j)))^Y.w2;
            set(i).R_our(j) = 1 - (1 - exp(-lambda*set(i).C(j)))^Y.our;
        else
            error('wrong priority');
        end
        
        % safety
        set(i).S_w2   = exp(-lambda*set(i).C(1)) * (1-( 1-exp(-lambda*set(i).C(2)) )^Y.w2) * M/(H/set(i).T(1) + H/set(i).T(2));
        set(i).S_our  = exp(-lambda*set(i).C(1)) * (1-( 1-exp(-lambda*set(i).C(2)) )^Y.our) * M/(H/set(i).T(1) + H/set(i).T(2));
    end
end


%% analysis
load evaluation_set.mat

C1(1) = evalSet.C(1);
T1(1) = evalSet.T(1);
C2(1) = evalSet.C(2);
T2(1) = evalSet.T(2);
U(1)  = C1(1)/T1(1) + C2(1)/T2(1);  

for i = 2:20
    T1(i) = T1(i-1)-1;
    T2(i) = T2(i-1)-1;
    C1(i) = C1(1);
    C2(i) = C2(1);
    
    U(i)  = C1(i)/T1(i) + C2(i)/T2(i);  
    
    % Rlo
    RLO.w2(i)  = exp(-lambda*C1(i));
    RLO.our(i) = exp(-lambda*C2(i));
    
    % Rhi
    RHI.w2(i)  = 1 - (1 - exp(-lambda*C2(i)))^Y.w2;
    RHI.our(i) = 1 - (1 - exp(-lambda*C2(i)))^Y.our;
    
    
    
end

range = 1:i;


% ploting

figure;
% plot(range, U, ':.r',range,T1,':.g',range,T2,':.b')
plot(range, U*100, ':.r',range,T1,':.g',range,T2,':.b')
xlabel('eval range')
grid on;


















