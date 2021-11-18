%% probability statistics: adding sw sequence restrictions

%% CLEAR: all workspace and global variables, and close all figues
clearvars -global; clearvars; close all; clc;

%% probability

pf = linspace(0.01, 0.9999, 10000);

vector_size = 10;
n  = linspace(1, vector_size, vector_size);
f  = 1*ones(1,length(n));

mode_failure = ones(length(pf), length(n));
for pf_index = 1:length(pf)
    for n_index = 1:length(n)
        for i_index = 1:n(n_index)
            mode_failure(pf_index, n_index) = mode_failure(pf_index, n_index) * ( 1 - ( 1 - pf(pf_index)^(2^n(i_index)) )^f(i_index) );
        end
    end
end

truncate_decimals = 4;
reliability = 1 - mode_failure;
truncated_reliability = fix(reliability * 10^(truncate_decimals))/(10^(truncate_decimals));


%%
figure;
plot(pf,reliability(:,1), 'LineWidth', 2);
grid on;

%% Finding n vectors for Pr = 0.9999 and Pr = 0.8000

for i = 1:length(n)
    % Pr = 0.9999
    temp = find(truncated_reliability(:,i) == 0.9999, 1);
    if isempty( temp ) == 1
        modes_0P9(i) = 0;
        m_0P9(i) = 0;
    else
        modes_0P9(i) = temp;
        m_0P9(i) = i;
    end
    
    % Pr = 0.8000
    temp = find(truncated_reliability(:,i) == 0.98, 1);
    if isempty( temp ) == 1
        modes_0P8(i) = 0;
        m_0P8(i) = 0;
    else
        modes_0P8(i) = temp;
        m_0P8(i) = i;
    end    
end

for i = 1:length(modes_0P9)
    if modes_0P9(i) == 0
        pf_per_mode_0P9(i) = 0; 
    else
        pf_per_mode_0P9(i) = pf( modes_0P9(i) ); 
    end
end

for i = 1:length(modes_0P8)
    if modes_0P8(i) == 0
        pf_per_mode_0P8(i) = 0; 
    else
        pf_per_mode_0P8(i) = pf( modes_0P8(i) ); 
    end
end

% Fixing vectors
pf_and_mode_0P9 = [modes_0P9' pf_per_mode_0P9' m_0P9'];
pf_and_mode_0P9( ~any(pf_and_mode_0P9, 2), : ) = [];  %rows

pf_and_mode_0P8 = [modes_0P8' pf_per_mode_0P8' m_0P8'];
pf_and_mode_0P8( ~any(pf_and_mode_0P8, 2), : ) = [];  %rows

%% Plotting results
figure;
stairs(pf_and_mode_0P9(:,2), pf_and_mode_0P9(:,3),'LineWidth',4); hold on;
stairs(pf_and_mode_0P8(:,2), pf_and_mode_0P8(:,3),'LineWidth',4); hold off;
grid on;
xlabel('P_f');
ylabel('Number of operational modes n');
legend('0P9', '0P8');