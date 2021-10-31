    % comparisons with state of the art
clear all
close all
clc


%% timing properties
max_T = 40;
iter  = 1:max_T;

% finding usability
for i = 1:max_T
    for j = 1:max_T
        C(i,j) = j;
        T(i,j) = C(i,1) + i;
                
        U.w2(i,j)  = C(i,j)/T(i,j) + 3*C(i,j)/T(i,j);
        U.our(i,j) = 4*( C(i,j)/T(i,j) + C(i,j)/T(i,j) );
    end   
end


figure;
plot(iter, U.w2, ':.g', iter, U.our, ':.b');
xlim([1 max_T]);
xlabel('iter');
ylabel('U');
grid on;


% combinations
% our 
% C = 1, T = [8-20]
% C = 2, T = [16-20]
% w2
% C = 1, T = [4-20]
% C = 2, T = [8-20]
% C = 3, T = [12-20]
% C = 4, T = [16-20]
% C = 5, T = 20

C = [1 1];
T = [5 10];
D = T;
L     = [1 1];
Y.w2  = [3 3];
Y.our = [4 4];

lambda = 1e-05; % reliablity consideration

% From task set
length_T = length(L);
H = elcm(T); % lcm of T

%% Reliability calculation

for i = 1:length_T    
    if L(i)==0 % LO
        R.w2(i)  = exp(-lambda*C(i));
        R.our(i) = exp(-lambda*C(i));
    elseif L(i)==1 % HI
        R.w2(i)  = 1 - (1 - exp(-lambda*C(i)))^Y.w2(i);
        R.our(i) = 1 - (1 - exp(-lambda*C(i)))^Y.our(i);
    else
        error('wrong priority');
    end
end


%% Safety calculation
M = 1; % # ration of instances that finish execution in time 1/1

S.w2  = exp(-lambda*C(1)) * (1-( 1-exp(-lambda*C(2)) )^3) * M/(H/T(1) + H/T(2));
S.our = exp(-lambda*C(1)) * (1-( 1-exp(-lambda*C(2)) )^4) * M/(H/T(1) + H/T(2));





















