%% solution of optimal control problem
clear all;
close all;
clc;

%% CT system
Ac = [0 1; 6.31 -15.48];
Bc = [0; 10]; % Bc_1
% Bc = [0; 1000]; % Bc_2

[ra, ca] = size(Ac);
[rb, cb] = size(Bc);

Cc = eye(ca);
Dc = zeros(rb, cb);

%% sampling interval and delay 
h     = 10e-3; % 10ms
delay = 4e-3; % 4ms


%% system discretization
% CT
sysc = ss(Ac, Bc, Cc, Dc); 

% DT
sysd    = c2d(sysc, h);  
sysd_b0 = c2d(sysc, h-delay);
sysd_b1 = c2d(sysc, h); 

A   = sysd.a; 
B_0 = sysd_b0.b;
B_1 = sysd_b1.b - B_0;

A_B = A*B_0 + B_1;


%% tolerated number of drops
m = 2;

%% Kj and Gj 
% j varies in [1,...,m]: in this case 0,1


Q1 = sdpvar(ra, ra);
Q2 = sdpvar(cb, cb);

% creating matrices
E{1} = sdpvar(cb, ra);
E{2} = sdpvar(cb, ra);
E{3} = sdpvar(cb, ra);

F{1} = sdpvar(cb, cb);
F{2} = sdpvar(cb, cb);
F{3} = sdpvar(cb, cb);


for j = 1:m
     
    % calculating L1_temp
    sum_L1_temp = 0;
    for l = 1:j
        sum_L1_temp = sum_L1_temp + ( A^(j-l) * A_B * E{l} );
    end
    L1_temp = (A^(j+1) * Q1) + sum_L1_temp + ( B_0 * E{j+1} );
        
    % calculating L2_temp
    sum_L2_temp = 0;
    for l = 1:j-1
        sum_L2_temp = sum_L2_temp + ( A^(j-l) * A_B * F{l} );
    end
    L2_temp = (A^j * B_1 * Q2) + sum_L2_temp + ( B_0 * F{j+1} );    
    
    % calculating matrix Lj    
    L{j} = [L1_temp L2_temp; E{j} F{j}];
              
end


% size of Lj
[rL, cL] = size(L{1});

% Q variable
Q = sdpvar(rL, cL);

% finding set of LMIs
M_SET_1 = [-Q L{1}; L{1} -Q];    
M_SET_2 = [-Q L{2}; L{2} -Q];    

% gamma
gamma = 0.9;


% LMI 1: transposed symmetry
M1 = [-gamma*Q1,         zeros(ca,cb),           transpose(A*Q1 + B_0*E{1}),     transpose(E{1}); ...
      zeros(cb,ca),      -gamma*Q2,              transpose(B_1*Q2 + B_0 * F{1}), transpose(F{1}); ...
      A*Q1 + B_0*E{1},   B_1*Q2 + B_0 * F{1},    -Q1,                            zeros(ca,cb); ...
      E{1},              F{1},                   zeros(cb,ca),                   -Q2];
  
% Tolerance
tol = 1e-7;
  
% consrtraints
const = [M_SET_1 <= 0, M_SET_2 <= 0, M1 <= 0, ...
         Q1 >= 0, Q2 >= 0];

     
options = sdpsettings('verbose',1,'solver','sedumi','sedumi.eps',1e-8);
solution = solvesdp(const, [], options);
solution.info

% solutions
Q1_sol = double(Q1);
Q2_sol = double(Q2);

E{1} = double(E{1});
E{2} = double(E{2});
E{3} = double(E{3});

F{1} = double(F{1});
F{2} = double(F{2});
F{3} = double(F{3});

K{1} = E{1} * (Q1_sol^-1);
K{2} = E{2} * (Q1_sol^-1);
K{3} = E{3} * (Q1_sol^-1);

G{1} = F{1} * (Q2_sol^-1);
G{2} = F{2} * (Q2_sol^-1);
G{3} = F{3} * (Q2_sol^-1);


%% simulation

time_vector = 0:h:1;                       
x0 = [0.25; 0]; % initial state
xk = [0; 0];

An1 = A + B_0*K{1};
An2 = B_1 + B_0*G{1};
An3 = K{1};
An4 = G{1};

% during no faults
An = [An1 An2; An3 An4];

% during faults
Ad_1_A0 = A^2 + A_B*K{1} + B_0*K{2};
Ad_1_A1 = A*B_1 + A_B*G{1} + B_0*G{2};
Ad_1 =  [Ad_1_A0 Ad_1_A1; K{2} G{2}];

Ad_2_A0 = A^3 + A*A_B*K{1} + A_B*K{2} + B_0*K{3};
Ad_2_A1 = (A^2)*B_1 + A*A_B*G{1} + B_0*G{3};
Ad_2 =  [Ad_2_A0 Ad_2_A1; K{3} G{3}];

uk   = zeros(1,6); % [ukp2 ukp1 uk ukm1 ukm2 ukm3] = [uk(1) uk(2) uk(3) uk(4) uk(5) uk(6)]
xk   = zeros(2,3); % [xk xkm1 xkm2] = [xk(1) xk(2) xk(3)]

j    = 0; % initialize no drop modeß
for i = 1:length(time_vector)        
    % switching to modes
    if i == 20 || i == 60 
        j = 1;
    elseif i == 40 || i == 50
        j = 2;
    else
        j = 0;
    end
    
    % shifting control input vector: history 
    uk(6) = uk(5);
    uk(5) = uk(4);
    uk(4) = uk(3);
    uk(3) = uk(2);
    uk(2) = uk(1);

     
    % shifting state vector: history
    xk(:,3) = xk(:,2);
    xk(:,2) = xk(:,1);
    
    if i == 1 % initializing first sample
        zkp1(:,1)    = [x0; 0];
    else
        % control input and state    
        if j == 1
            uk(2)       = K{2}*xk(:,2) + G{2}*uk(5);
            zkp1(:,i)   = Ad_1 * [xk(:,2); uk(5)];
        elseif j == 2
            uk(1)       = K{3}*xk(:,2) + G{3}*uk(5);
            zkp1(:,i)   = Ad_1 * [xk(:,3); uk(6)];
        else % j == 0
            uk(3)       = K{1}*xk(:,2) + G{1}*uk(5);
            zkp1(:,i)   = An * [xk(:,1); uk(4)];
        end
    end
    
    xk(:,1) = zkp1(1:end-1,i);
end

%% plots
figure; 
subplot(3,1,1);
plot(time_vector,zkp1(1,:), ':.');
xlabel('time [s]'); ylabel('x_1 [k]');

subplot(3,1,2);
plot(time_vector,zkp1(2,:), ':.');
xlabel('time [s]'); ylabel('x_2 [k]');

subplot(3,1,3);
plot(time_vector,zkp1(3,:), ':.');
xlabel('time [s]'); ylabel('u [k]');