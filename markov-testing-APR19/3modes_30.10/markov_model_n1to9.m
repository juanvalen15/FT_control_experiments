%% script to plot results
clear all;
close all;
clc;

%% calling scripts
for results_index = 1:9
    % settings
    Ps_sim = 0.5;
    Ps_granularity_sim = 0.1;
    Plots_on_off = 0;
    sim_loops = 1000;
    
    % running
    run(['markov_model_n_' num2str(results_index)]);
    save(['n' num2str(results_index) '_results.mat'], ['t_N' num2str(results_index)], ['R_N' num2str(results_index)]);
    
    clear all;
end


%% loading results
for results_index = 1:9
    load(['n' num2str(results_index) '_results']);
end

t_matrix = [t_N1{1},t_N2{1},t_N3{1},t_N4{1},t_N5{1},t_N6{1},t_N7{1},t_N8{1},t_N9{1}];
R_matrix = [R_N1{1},R_N2{1},R_N3{1},R_N4{1},R_N5{1},R_N6{1},R_N7{1},R_N8{1},R_N9{1}];

% t_matrix = [t_N1{1},t_N2{2},t_N3{2},t_N4{2},t_N5{2},t_N6{2},t_N7{2},t_N8{2},t_N9{2}];
% R_matrix = [R_N1{1},R_N2{2},R_N3{2},R_N4{2},R_N5{2},R_N6{2},R_N7{2},R_N8{2},R_N9{2}];


%% ploting

figure;
p = plot(t_matrix, R_matrix, ':.');
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
xlim([0 5000]);
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
