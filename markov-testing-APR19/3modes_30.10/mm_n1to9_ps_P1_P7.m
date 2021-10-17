%% script to plot results
clear all;
close all;
clc;

%% calling scripts
for results_index = 1:9
    for Ps_sim = 0.1:0.1:0.7
        % settings
        Ps_granularity_sim = 0.1;
        Plots_on_off = 0;
        sim_loops = 10000;
        
        % running
        run(['markov_model_n_' num2str(results_index)]);
        save(['n' num2str(results_index) '_Ps_' num2str(Ps_sim) '_results.mat'], ['t_N' num2str(results_index)], ['R_N' num2str(results_index)]);
    end
    clear all;
end


%% loading results
t_matrix = [];
R_matrix = [];
for results_index = 1:9
    temp_index = 0;
    for Ps_sim = 1:1:7
        temp_index = Ps_sim/10;
        load(['n' num2str(results_index) '_Ps_' num2str(temp_index) '_results.mat']);
        
        switch results_index
            case 1
                t_matrix{Ps_sim,results_index} = t_N1{1};
                R_matrix{Ps_sim,results_index} = R_N1{1};
            case 2
                t_matrix{Ps_sim,results_index} = t_N2{1};
                R_matrix{Ps_sim,results_index} = R_N2{1};
            case 3
                t_matrix{Ps_sim,results_index} = t_N3{1};
                R_matrix{Ps_sim,results_index} = R_N3{1};
            case 4
                t_matrix{Ps_sim,results_index} = t_N4{1};
                R_matrix{Ps_sim,results_index} = R_N4{1};
            case 5
                t_matrix{Ps_sim,results_index} = t_N5{1};
                R_matrix{Ps_sim,results_index} = R_N5{1};
            case 6
                t_matrix{Ps_sim,results_index} = t_N6{1};
                R_matrix{Ps_sim,results_index} = R_N6{1};
            case 7
                t_matrix{Ps_sim,results_index} = t_N7{1};
                R_matrix{Ps_sim,results_index} = R_N7{1};
            case 8
                t_matrix{Ps_sim,results_index} = t_N8{1};
                R_matrix{Ps_sim,results_index} = R_N8{1};
            otherwise
                t_matrix{Ps_sim,results_index} = t_N9{1};
                R_matrix{Ps_sim,results_index} = R_N9{1};
        end
    end
end


%% data arrangement
t1 = [t_matrix{1,1} t_matrix{1,2} t_matrix{1,3} t_matrix{1,4} t_matrix{1,5} t_matrix{1,6} t_matrix{1,7} t_matrix{1,8} t_matrix{1,9}];
t2 = [t_matrix{2,1} t_matrix{2,2} t_matrix{2,3} t_matrix{2,4} t_matrix{2,5} t_matrix{2,6} t_matrix{2,7} t_matrix{2,8} t_matrix{2,9}];
t3 = [t_matrix{3,1} t_matrix{3,2} t_matrix{3,3} t_matrix{3,4} t_matrix{3,5} t_matrix{3,6} t_matrix{3,7} t_matrix{3,8} t_matrix{3,9}];
t4 = [t_matrix{4,1} t_matrix{4,2} t_matrix{4,3} t_matrix{4,4} t_matrix{4,5} t_matrix{4,6} t_matrix{4,7} t_matrix{4,8} t_matrix{4,9}];
t5 = [t_matrix{5,1} t_matrix{5,2} t_matrix{5,3} t_matrix{5,4} t_matrix{5,5} t_matrix{5,6} t_matrix{5,7} t_matrix{5,8} t_matrix{5,9}];
t6 = [t_matrix{6,1} t_matrix{6,2} t_matrix{6,3} t_matrix{6,4} t_matrix{6,5} t_matrix{6,6} t_matrix{6,7} t_matrix{6,8} t_matrix{6,9}];
t7 = [t_matrix{7,1} t_matrix{7,2} t_matrix{7,3} t_matrix{7,4} t_matrix{7,5} t_matrix{7,6} t_matrix{7,7} t_matrix{7,8} t_matrix{7,9}];

R1 = [R_matrix{1,1} R_matrix{1,2} R_matrix{1,3} R_matrix{1,4} R_matrix{1,5} R_matrix{1,6} R_matrix{1,7} R_matrix{1,8} R_matrix{1,9}];
R2 = [R_matrix{2,1} R_matrix{2,2} R_matrix{2,3} R_matrix{2,4} R_matrix{2,5} R_matrix{2,6} R_matrix{2,7} R_matrix{2,8} R_matrix{2,9}];
R3 = [R_matrix{3,1} R_matrix{3,2} R_matrix{3,3} R_matrix{3,4} R_matrix{3,5} R_matrix{3,6} R_matrix{3,7} R_matrix{3,8} R_matrix{3,9}];
R4 = [R_matrix{4,1} R_matrix{4,2} R_matrix{4,3} R_matrix{4,4} R_matrix{4,5} R_matrix{4,6} R_matrix{4,7} R_matrix{4,8} R_matrix{4,9}];
R5 = [R_matrix{5,1} R_matrix{5,2} R_matrix{5,3} R_matrix{5,4} R_matrix{5,5} R_matrix{5,6} R_matrix{5,7} R_matrix{5,8} R_matrix{5,9}];
R6 = [R_matrix{6,1} R_matrix{6,2} R_matrix{6,3} R_matrix{6,4} R_matrix{6,5} R_matrix{6,6} R_matrix{6,7} R_matrix{6,8} R_matrix{6,9}];
R7 = [R_matrix{7,1} R_matrix{7,2} R_matrix{7,3} R_matrix{7,4} R_matrix{7,5} R_matrix{7,6} R_matrix{7,7} R_matrix{7,8} R_matrix{7,9}];


[rows, columns] = size(R1);
for i = 1:rows
    for j = 1:columns
        if R1(i,j) <0; R1(i,j) = 0; end
        if R2(i,j) <0; R2(i,j) = 0; end
        if R3(i,j) <0; R3(i,j) = 0; end
        if R4(i,j) <0; R4(i,j) = 0; end
        if R5(i,j) <0; R5(i,j) = 0; end
        if R6(i,j) <0; R6(i,j) = 0; end
        if R7(i,j) <0; R7(i,j) = 0; end
    end
end

%% ploting

figure;
p = plot(t3, R3, ':.');
p(1).Marker = '.';
p(2).Marker = '*';
p(3).Marker = 'hexagram';
p(4).Marker = '>';
p(5).Marker = '<';
p(6).Marker = '+';
p(7).Marker = 'o';
p(8).Marker = 'square';
p(9).Marker = 'x';

grid on;
xlabel('time [slots]');
ylabel('reliability [probability]');
xlim([0 10000]);
ylim([0 1]);
% legend('n=1 | no FT', ...
%        'n=2 | FT with f=[1 1]', ...
%        'n=3 | FT with f=[1 1 1]', ...
%        'n=4 | FT with f=[1 1 1 1]', ...
%        'n=5 | FT with f=[1 1 1 1 1]', ...
%        'n=6 | FT with f=[1 1 1 1 1 1]', ...
%        'n=7 | FT with f=[1 1 1 1 1 1 1]', ...
%        'n=8 | FT with f=[1 1 1 1 1 1 1 1]', ...
%        'n=9 | FT with f=[1 1 1 1 1 1 1 1 1]');

% legend('n=1 | no FT', ...
%        'n=2 | FT with f=[3 3]', ...
%        'n=3 | FT with f=[3 3 3]', ...
%        'n=4 | FT with f=[3 3 3 3]', ...
%        'n=5 | FT with f=[3 3 3 3 3]', ...
%        'n=6 | FT with f=[3 3 3 3 3 3]', ...
%        'n=7 | FT with f=[3 3 3 3 3 3 3]', ...
%        'n=8 | FT with f=[3 3 3 3 3 3 3 3]', ...
%        'n=9 | FT with f=[3 3 3 3 3 3 3 3 3]');

legend('n=1 | BL', ...
    'n=2 | FT with f=[2 2]', ...
    'n=3 | FT with f=[1 1 2]', ...
    'n=4 | FT with f=[1 3 2 2]', ...
    'n=5 | FT with f=[1 3 2 2 3]', ...
    'n=6 | FT with f=[1 1 2 2 3 3]', ...
    'n=7 | FT with f=[1 1 3 2 3 2 3]', ...
    'n=8 | FT with f=[1 1 2 2 2 3 3 3]', ...
    'n=9 | FT with f=[1 1 2 2 2 2 3 2 3]');


%% fixed time instant
time_stamp = find(t1(:,1) == 100);

R_fixed_time = [
R1(time_stamp,:);
R2(time_stamp,:);
R3(time_stamp,:);
R4(time_stamp,:);
R5(time_stamp,:);
R6(time_stamp,:);
R7(time_stamp,:);
];


figure;
p = plot(t5, R5, ':.');
p(1).Marker = '.';
p(2).Marker = '*';
p(3).Marker = 'hexagram';
p(4).Marker = '>';
p(5).Marker = '<';
p(6).Marker = '+';
p(7).Marker = 'o';
p(8).Marker = 'square';
p(9).Marker = 'x';

grid on;
xlabel('P_s [probability]');
ylabel('P_r [probability]');
% xlim([0 1]);
% ylim([0 1]);


legend('n=1 | BL', ...
    'n=2 | FT with f=[2 2]', ...
    'n=3 | FT with f=[1 1 2]', ...
    'n=4 | FT with f=[1 3 2 2]', ...
    'n=5 | FT with f=[1 3 2 2 3]', ...
    'n=6 | FT with f=[1 1 2 2 3 3]', ...
    'n=7 | FT with f=[1 1 3 2 3 2 3]', ...
    'n=8 | FT with f=[1 1 2 2 2 3 3 3]', ...
    'n=9 | FT with f=[1 1 2 2 2 2 3 2 3]');
