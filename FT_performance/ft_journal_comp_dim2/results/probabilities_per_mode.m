%% probability statistics for each mode 
%% CLEAR: all workspace and global variables, and close all figues
clearvars -global; clearvars; close all; clc;

%% probability

pf = linspace(0.01, 0.9999, 100);

f_constant = 1;

vector_size = 3;
n  = linspace(1, vector_size, vector_size);
f  = f_constant*ones(1,length(n));

mode_failure = ones(length(pf), length(n));
for pf_index = 1:length(pf)
    for n_index = 1:length(n)
        if n_index == 3
            f = [1 1 3];
        end
        for i_index = 1:n(n_index)           
            mode_failure(pf_index, n_index) = mode_failure(pf_index, n_index) * ( 1 - ( 1 - pf(pf_index)^(2^n(i_index)) )^f(i_index) );
        end
    end
end

pr_baseline = 1-pf;
reliability = 1 - mode_failure;
reliability123 = reliability(:,3);

save reliability_f123.mat reliability pr_baseline

%%
load reliability_f1.mat
pf_f1 = pf;
pr_baseline_f1 = pr_baseline;
reliability_f1 = reliability;

load reliability_f10.mat
pf_f10 = pf;
pr_baseline_f10 = pr_baseline;
reliability_f10 = reliability;

load reliability_f123.mat
pf_f123 = pf;
pr_baseline_f123 = pr_baseline;
reliability_f123 = reliability123;




%%

figure;
plot(pf_f1,pr_baseline_f1, '-', ...
     pf_f1,reliability_f1(:,1), ':.', ...
     pf_f1,reliability_f1(:,2), '*',...
     pf_f1,reliability_f1(:,3), 'md',...
     'LineWidth', 1);
grid on;
HL = legend('no redundancy','n=1 : f_{sw}=1','n=2 : f_{sw}=(1,1)','n=3 : f_{sw}=(1,1,1)');
HX = xlabel('P_f');
HY = ylabel('P_r');

                          
set(gca,'fontsize',11)
set(HX,'FontSize', 14);
set(HY,'FontSize', 14);
set(HL,'FontSize', 12);


%%

figure;
plot(pf_f10,pr_baseline_f10, '-', ...
     pf_f10,reliability_f10(:,1), ':.', ...
     pf_f10,reliability_f10(:,2), '*',...
     pf_f10,reliability_f10(:,3), 'md',...
     'LineWidth', 1);
grid on;
HL = legend('no redundancy','n=1 : f_{sw}=10','n=2 : f_{sw}=(10,10)','n=3 : f_{sw}=(10,10,10)');
HX = xlabel('P_f');
HY = ylabel('P_r');

set(gca,'fontsize',11)
set(HX,'FontSize', 14);
set(HY,'FontSize', 14);
set(HL,'FontSize', 12);


%%

figure;
plot(pf_f123,pr_baseline_f123, '-', ...
     pf_f123,reliability_f123, 'md', ...
     0.5*ones(1,length(pf)), pf, 'g--', ...
     'LineWidth', 1);
grid on;
HL = legend('no redundancy','n=3 : f_{sw}=(1,1,3)','actual actuation limit : P_f=0.5');
HX = xlabel('P_f');
HY = ylabel('P_r');

set(gca,'fontsize',11)
set(HX,'FontSize', 14);
set(HY,'FontSize', 14);
set(HL,'FontSize', 12);

% export_fig(['pr_pf_m3_f113.pdf'], '-pdf','-transparent');



%% combined f1 and f10

figure;
plot(pf_f1,pr_baseline_f1, '-', ...
     pf_f1,reliability_f1(:,1), 'r:.', ...
     pf_f1,reliability_f1(:,2), 'r*',...
     pf_f1,reliability_f1(:,3), 'rd',...     
     pf_f10,reliability_f10(:,1), 'g:.', ...
     pf_f10,reliability_f10(:,2), 'g*',...
     pf_f10,reliability_f10(:,3), 'gd',...     
     'LineWidth', 1);

grid on;

 

HL = legend('no redundancy', ...
            'n=1 : f_{sw}=1','n=2 : f_{sw}=(1,1)','n=3 : f_{sw}=(1,1,1)', ...
            'n=1 : f_{sw}=10','n=2 : f_{sw}=(10,10)','n=3 : f_{sw}=(10,10,10)');

HX = xlabel('P_f');
HY = ylabel('P_r');
                          
set(gca,'fontsize',11)
set(HX,'FontSize', 14);
set(HY,'FontSize', 14);
set(HL,'FontSize', 12);




%%
% export_fig(['pr_vs_pf.pdf'], '-pdf','-transparent');


