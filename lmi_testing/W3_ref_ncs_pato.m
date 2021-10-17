%% solution of optimal control problem
clear all;
close all;
clc;

%% CT system
% System parameters
J1 = 3.75e-6;  % inertia [Kgm^2]
J2 = 3.75e-6;  % inertia [Kgm^2]
b  = 1e-5;     % friction coefficient [Nms/rad]
k  = 0.2656;   % torsional spring [Nm/rad]
d  = 3.125e-5; % torsional damping [Nms/rad]
Km = 4.4e-2;   % motor constant [Nm/A]

% State space
Ac = [0 0 1 0 ; 0 0 0 1; -k/J1  k/J1 -(d+b)/J1 d/J1; k/J2 -k/J2  d/J2 -(d+b)/J2];
Bc = [0; 0; Km/J1; 0];

[ra, ca] = size(Ac);
[rb, cb] = size(Bc);
dim = ra; % sys dimension
dim_aug = dim + 1; % aug. sys dimension

Cc = eye(ca);
Dc = zeros(rb, cb);



%% system discretization and augmentation
H = [10e-3 20e-3 40e-3]; % [10ms 20ms 40ms]
D = [5.2e-3 15.2e-3 35.2e-3]; % [5.2ms 15.2ms 35.2ms]

% CT
sysc = ss(Ac, Bc, Cc, Dc); 

% DT
for i = 1:length(H)
    sysd    = c2d(sysc, H(i)); 

    Ad{i} = sysd.a; 
    Bd{i} = sysd.b; 

    sysd_b0 = c2d(sysc, H(i)-D(i)); 
    sysd_b1 = c2d(sysc, H(i)); 
    B_0{i} = sysd_b0.b;
    B_temp = sysd_b1.b;
    B_1{i} = B_temp - B_0{i};

    A_aug{i} = [Ad{i}  B_1{i}; zeros(1,dim+1)];
    B_aug{i} = [B_0{i}; 1];
end


%% variables
Q{1} = sdpvar(dim_aug,dim_aug);
Q{2} = sdpvar(dim_aug,dim_aug);
Q{3} = sdpvar(dim_aug,dim_aug);

theta{1} = sdpvar(cb, dim_aug);
theta{2} = sdpvar(cb, dim_aug);
theta{3} = sdpvar(cb, dim_aug);

L     = 1; % no actuator fault : constant because we onyl use one actuator
alpha = 0.2; 
mu    = 1;

% constructing lmis
for i = 1:length(H)
    M{i} = [-(1-alpha) * Q{i},                          (Q{i} * A_aug{i}') + (theta{i}' * L' * B_aug{i}'); ...
            (A_aug{i} * Q{i}) + (B_aug{i} * theta{i}),  -Q{i}];        
end

% Tolerance
tol = 1e-7;
  
% consrtraints
const = [M{1} <= 0, M{2} <= 0, M{3} <= 0, ... 
         Q{1} >= 0, Q{2} >= 0, Q{3} >= 0];

     
options = sdpsettings('verbose',1,'solver','sedumi','sedumi.eps',1e-8);
solution = solvesdp(const, [], options);
solution.info

% solutions
Q1_sol = double(Q{1});
Q2_sol = double(Q{2});
Q3_sol = double(Q{3});

theta_1_sol = double(theta{1});
theta_2_sol = double(theta{2});
theta_3_sol = double(theta{3});

% feedback control gains
K{1} = theta_1_sol * inv(Q1_sol);
K{2} = theta_2_sol * inv(Q2_sol);
K{3} = theta_3_sol * inv(Q3_sol);





%% simulation

sim_time = 1; % approx 1 second
switching_sequence = [1];
                   
x0 = [1; 1; 1; 1]; % initial state
uk   = zeros(1,2); % [uk ukm1] = [uk(1) uk(2)]

time_vector = 0;  
sample = 0;


for i = 1:ceil(sim_time / sum(H(switching_sequence)))
    
    for j = 1:length(switching_sequence)        
        % sample update
        sample = sample + 1;
                       
        % subsystem
        %sys = switching_sequence(j);
        
        % setting L and subsystem
        if sample == 6 || sample == 47
            L(sample) = 1;
            sys = 2;            
        else
            L(sample) = 1;
            sys = 1;
        end        
                
        % shifting control input vector: history 
        uk(2) = uk(1);     
        
        % calculating augmented state zk AND update time vector       
        if i == 1 && j == 1            
            zk = [x0; uk(2)];
            time_vector(sample) = 0;
        else
            zk = [xk; uk(2)];
            time_vector(sample) = time_vector(sample-1) + H(sys);
        end
                
        % calculating control action
        uk(1) = K{sys} * zk;
        
        % calculating CL matrix
        M_CL = A_aug{sys} + B_aug{sys} * L(sample) * K{sys};     
        
        % calculating next state
        if i == 1 && j == 1            
            zkp1(:,sample) = [x0; 0];
        else
            zkp1(:,sample) = M_CL * zk;
        end        
%         zkp1(:,sample) = M_CL * zk;
        
        % updating xk
        xk = zkp1(1:end-1,sample);
    end
       
end

save('sim_W3_ref_results', 'zkp1', 'time_vector');

%% plots
%%
figure; 
subplot(4,1,1);
plot(time_vector,zkp1(1,:), ':.');
xlabel('time [s]'); ylabel('x_1 [k]');
xlim([0 1]);

subplot(4,1,2);
plot(time_vector,zkp1(3,:), ':.');
xlabel('time [s]'); ylabel('x_3 [k]');
xlim([0 1]);

subplot(4,1,3);
plot(time_vector,zkp1(5,:), ':.');
xlabel('time [s]'); ylabel('u [k]');
xlim([0 1]);

subplot(4,1,4);
plot(time_vector,L, ':.');
xlabel('time [s]'); ylabel('L');
xlim([0 1]);

% %%
% load sim_ft_2faults_1s.mat;
% figure; 
% subplot(3,1,1);
% plot(time_vector,zkp1(1,:), ':.', ...
%      sensed_data_x1.Time(1:201), sensed_data_x1.Data(1:201), ':.');
% xlabel('time [s]'); ylabel('\theta_1 [rad]');
% grid on;
% grid minor;
% legend('PD', 'SM');
% 
% subplot(3,1,2);
% plot(time_vector,zkp1(3,:), ':.', ...
%      sensed_data_x3.Time(1:201), sensed_data_x3.Data(1:201), ':.');
% xlabel('time [s]'); ylabel('\omega_1 [rad/s]');
% grid on;
% grid minor;
% legend('PD', 'SM');
% 
% subplot(3,1,3);
% plot(time_vector,zkp1(5,:), ':.', ...
%      actuation_signal_u.Time(1:201), actuation_signal_u.Data(1:201), ':.');
% xlabel('time [s]'); ylabel('u [A]');
% grid on;
% grid minor;
% legend('PD', 'SM');
% 
