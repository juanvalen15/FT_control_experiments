% visualizing results
clear all;
close all;
clc;

% load data
for n = 2:10    
    for fsw_index = 1:2
        
        for pf_index = 1:1:7
            load(['results_n_2_to_10/results_ft_n_' num2str(n) '_fsw_' num2str(fsw_index) '_Pf_' num2str(pf_index/10) '.mat']);
%             load(['results_n_2_to_10/results_ft_n_' num2str(n) '_fsw_' num2str(fsw_index) '_Pf_' num2str(pf_index/10) '.mat']);
            
            mean_ft{n}(fsw_index, pf_index) = mean_ft_sim;
            mean_bl{n}(fsw_index, pf_index) = mean_bl_sim;
            
        end
        
    end
end


%% merging data
set_mean_bl_and_ft_f_min = [mean_bl{2}(1,:); ...
                            mean_ft{2}(1,:); mean_ft{3}(1,:); mean_ft{4}(1,:); mean_ft{5}(1,:); ...
                            mean_ft{6}(1,:); mean_ft{7}(1,:); mean_ft{8}(1,:); mean_ft{9}(1,:)];

set_mean_bl_and_ft_f_max = [mean_bl{2}(1,:); ...
                            mean_ft{2}(2,:); mean_ft{3}(2,:); mean_ft{4}(2,:); mean_ft{5}(2,:); ...
                            mean_ft{6}(2,:); mean_ft{7}(2,:); mean_ft{8}(2,:); mean_ft{9}(2,:)];        
                 

% plot
figure;

p = semilogy([.1 .2 .3 .4 .5 .6 .7],set_mean_bl_and_ft_f_min', ':.', 'MarkerSize', 8); 
grid on; grid minor;
xlabel('P_s [probability]');
ylabel('MAE [radians]');

p(1).Marker = '.';
p(2).Marker = '*';
p(3).Marker = 'hexagram';
p(4).Marker = '>';
p(5).Marker = '<';
p(6).Marker = '+';
p(7).Marker = 'o';
p(8).Marker = 'square';
p(9).Marker = 'x';

legend('n=1 | BL', ...
       'n=2 | FT with f=[2 2]', ...
       'n=3 | FT with f=[1 1 2]', ...
       'n=4 | FT with f=[1 3 2 2]', ...
       'n=5 | FT with f=[1 3 2 2 3]', ...
       'n=6 | FT with f=[1 1 2 2 3 3]', ...
       'n=7 | FT with f=[1 1 3 2 3 2 3]', ...
       'n=8 | FT with f=[1 1 2 2 2 3 3 3]', ...
       'n=9 | FT with f=[1 1 2 2 2 2 3 2 3]', ...
       'Location', 'Best');


   
   
figure;

p = semilogy([.1 .2 .3 .4 .5 .6 .7],set_mean_bl_and_ft_f_max', ':.', 'MarkerSize', 8); 
grid on; grid minor;
xlabel('P_s [probability]');
ylabel('MAE [radians]');    

p(1).Marker = '.';
p(2).Marker = '*';
p(3).Marker = 'hexagram';
p(4).Marker = '>';
p(5).Marker = '<';
p(6).Marker = '+';
p(7).Marker = 'o';
p(8).Marker = 'square';
p(9).Marker = 'x';

legend('n=1 | BL', ...
       'n=2 | FT with f=[3 3]', ...
       'n=3 | FT with f=[3 3 3]', ...
       'n=4 | FT with f=[3 3 3 3]', ...
       'n=5 | FT with f=[3 3 3 3 3]', ...
       'n=6 | FT with f=[3 3 3 3 3 3]', ...
       'n=7 | FT with f=[3 3 3 3 3 3 3]', ...
       'n=8 | FT with f=[3 3 3 3 3 3 3 3]', ...
       'n=9 | FT with f=[3 3 3 3 3 3 3 3 3]', ...
       'Location', 'Best');
   


                 

%% normalization
max_ft_temp = [];
max_bl_temp = [];
for i = 2:10
    max_ft_temp = [max_ft_temp max(mean_ft{i}(1,:)) max(mean_ft{i}(2,:))];
    max_bl_temp = [max_bl_temp max(mean_bl{i}(1,:)) max(mean_bl{i}(2,:))];
end

max_ft = max(max_ft_temp);
max_bl = max(max_bl_temp);


%% comparing ft vs. bl with fixed fsw (fastest)
figure;
for i = 2:9
    subplot(2,4,i-1);
    semilogy(0.1:0.1:0.7, mean_ft{i}(1,:)./max_ft,'r-*','LineWidth', 3, 'MarkerSize', 8); hold on
    semilogy(0.1:0.1:0.7, mean_bl{2}(1,:)./max_bl,'b-*','LineWidth', 3, 'MarkerSize', 8); hold off
    grid on;title(['n= ' num2str(i)]);    
    legend('FT', 'BL','Location', 'NorthWest');
    xlabel('Ps [probability]'); ylabel('Normalized error');
    ylim([0 1]);
end

%% varying fsw
figure;
for i = 2:9
    subplot(2,4,i-1);
    semilogy(0.1:0.1:0.7, mean_ft{i}(1,:)./max_ft,'r-*','LineWidth', 3, 'MarkerSize', 8); hold on
    semilogy(0.1:0.1:0.7, mean_ft{i}(2,:)./max_ft,'b-*','LineWidth', 3, 'MarkerSize', 8); hold off
    grid on;title(['n= ' num2str(i)]);
    if i == 2
        legend('[2 2]', '[3 3]','Location', 'NorthWest');
    elseif i == 3
        legend('[1 1 2]', '[3 3 3]','Location', 'NorthWest');
    elseif i == 4
        legend('[1 3 2 3]', '[3 3 3 3]','Location', 'NorthWest');
    elseif i == 5
        legend('[1 3 2 2 3]', '[3 3 3 3 3]','Location', 'NorthWest');
    elseif i == 6
        legend('[1 1 2 2 3 3]', '[3 3 3 3 3 3]','Location', 'NorthWest');
    elseif i == 7
        legend('[1 1 3 2 3 2 3]', '[3 3 3 3 3 3 3]','Location', 'NorthWest');
    elseif i == 8
        legend('[1 1 2 2 2 3 3 3]', '[3 3 3 3 3 3 3 3]','Location', 'NorthWest');
    elseif i == 9
        legend('[1 1 2 2 2 2 3 2 3]', '[3 3 3 3 3 3 3 3 3]','Location', 'NorthWest');
    else
        legend('fast', 'slow','Location', 'NorthWest');
    end
    xlabel('Ps [probability]'); ylabel('Normalized error');
    ylim([0 1]);
end