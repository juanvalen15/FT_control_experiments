% visualizing results
clear all;
close all;
clc;

% load data
for n = 2:4   
    for fsw_index = 1:2
        
        for pf_index = 1:1:6
            load(['results_n_2_to_10/results_ft_n_' num2str(n) '_fsw_' num2str(fsw_index) '_Pf_' num2str(pf_index/10) '.mat']);
            
            mean_ft{n}(fsw_index, pf_index) = mean_ft_sim;
            iae_ft{n}(fsw_index, pf_index)  = iae_ft_sim;
            ise_ft{n}(fsw_index, pf_index)  = ise_ft_sim;
            itae_ft{n}(fsw_index, pf_index) = itae_ft_sim;
            
            mean_bl{n}(fsw_index, pf_index) = mean_bl_sim;
            iae_bl{n}(fsw_index, pf_index)  = iae_bl_sim;
            ise_bl{n}(fsw_index, pf_index)  = ise_bl_sim;
            itae_bl{n}(fsw_index, pf_index) = itae_bl_sim;
            
        end
        
    end
end


%% merging data
% set_mean_bl_and_ft_f_min = [mean_bl{2}(1,:); mean_ft{2}(1,:); mean_ft{3}(1,:); mean_ft{4}(1,:);];
% set_mean_bl_and_ft_f_max = [mean_bl{2}(1,:); mean_ft{2}(2,:); mean_ft{3}(2,:); mean_ft{4}(2,:);];        
set_mean_bl_and_ft_f_min = [mean_ft{2}(1,:); mean_ft{3}(1,:); mean_ft{4}(1,:);];
set_mean_bl_and_ft_f_max = [mean_ft{2}(2,:); mean_ft{3}(2,:); mean_ft{4}(2,:);];        


set_iae_bl_and_ft_f_min  = [iae_bl{2}(1,:); ...
                            iae_ft{2}(1,:); ...
                            iae_ft{3}(1,:); ...
                            iae_ft{4}(1,:)];

set_iae_bl_and_ft_f_max  = [iae_bl{2}(1,:); ...
                            iae_ft{2}(2,:); ...
                            iae_ft{3}(2,:); ...
                            iae_ft{4}(2,:)];                                    

set_ise_bl_and_ft_f_min  = [ise_bl{2}(1,:); ...
                            ise_ft{2}(1,:); ...
                            ise_ft{3}(1,:); ...
                            ise_ft{4}(1,:)];
                        
set_ise_bl_and_ft_f_max  = [ise_bl{2}(1,:); ...
                            ise_ft{2}(2,:); ...
                            ise_ft{3}(2,:); ...
                            ise_ft{4}(2,:)];     

set_itae_bl_and_ft_f_min  =[itae_bl{2}(1,:); ...
                            itae_ft{2}(1,:); ...
                            itae_ft{3}(1,:); ...
                            itae_ft{4}(1,:)];                        
                        
set_itae_bl_and_ft_f_max  =[itae_bl{2}(1,:); ...
                            itae_ft{2}(2,:); ...
                            itae_ft{3}(2,:); ...
                            itae_ft{4}(2,:);];                                                                                                                                                   
   
   
%% MAE vs Ps with fsw max (worst case switching)
figure;

x = [.1 .2 .3 .4 .5 .6];

p1 = semilogy(x, mean_bl{2}(1,:), 'r:o', ...             
             'LineWidth', 3, 'MarkerSize', 8); 
         
hold on;
p2 = semilogy(x, mean_ft{2}(1,:), 'b:o', ...
             x, mean_ft{3}(1,:), 'm:o', ...
             x, mean_ft{4}(1,:), 'c:o', ...
             'LineWidth', 3, 'MarkerSize', 8); 
grid on; grid minor;
xlabel('P_s [probability]');
ylabel('MAE [radians]');    

hold on;
p3 = semilogy(x, mean_ft{2}(2,:), 'bo-', ...
             x, mean_ft{3}(2,:), 'mo-', ...
             x, mean_ft{4}(2,:), 'co-', ...
             'LineWidth', 3, 'MarkerSize', 8); 
grid on; grid minor;
xlabel('P_s [probability]');
ylabel('MAE [radians]');


legend('n=1 | BL', ...
       'n=2 | FT with f=[2 2]', ...
       'n=3 | FT with f=[1 1 2]', ...
       'n=4 | FT with f=[1 3 2 2]', ...
       'n=2 | FT with f=[3 3]', ...
       'n=3 | FT with f=[3 3 3]', ...
       'n=4 | FT with f=[3 3 3 3]', ...
       'Location', 'Best');   



                 
   
%% IAE vs Ps with fsw max (worst case switching)
figure;

subplot(1,2,1);
p = plot([.1 .2 .3 .4 .5 .6],set_iae_bl_and_ft_f_max', ':.', 'LineWidth', 3, 'MarkerSize', 8); 
grid on; grid minor;
xlabel('P_s [probability]');
ylabel('IAE [radians]');    

p(1).Marker = '.';
p(2).Marker = '*';
p(3).Marker = 'hexagram';
p(4).Marker = '>';
% p(5).Marker = '<';
% p(6).Marker = '+';
% p(7).Marker = 'o';
% p(8).Marker = 'square';
% p(9).Marker = 'x';

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

subplot(1,2,2);
p = plot([.1 .2 .3 .4 .5 .6],set_iae_bl_and_ft_f_min', ':.', 'LineWidth', 3, 'MarkerSize', 8); 
grid on; grid minor;
xlabel('P_s [probability]');
ylabel('IAE [radians]');

p(1).Marker = '.';
p(2).Marker = '*';
p(3).Marker = 'hexagram';
p(4).Marker = '>';
% p(5).Marker = '<';
% p(6).Marker = '+';
% p(7).Marker = 'o';
% p(8).Marker = 'square';
% p(9).Marker = 'x';

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


%% ISE vs Ps with fsw max (worst case switching)
figure;

subplot(1,2,1);
p = plot([.1 .2 .3 .4 .5 .6],set_ise_bl_and_ft_f_max', ':.', 'LineWidth', 3, 'MarkerSize', 8); 
grid on; grid minor;
xlabel('P_s [probability]');
ylabel('ISE [radians]');    

p(1).Marker = '.';
p(2).Marker = '*';
p(3).Marker = 'hexagram';
p(4).Marker = '>';
% p(5).Marker = '<';
% p(6).Marker = '+';
% p(7).Marker = 'o';
% p(8).Marker = 'square';
% p(9).Marker = 'x';

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

subplot(1,2,2);
p = plot([.1 .2 .3 .4 .5 .6],set_ise_bl_and_ft_f_min', ':.', 'LineWidth', 3, 'MarkerSize', 8); 
grid on; grid minor;
xlabel('P_s [probability]');
ylabel('ISE [radians]');

p(1).Marker = '.';
p(2).Marker = '*';
p(3).Marker = 'hexagram';
p(4).Marker = '>';
% p(5).Marker = '<';
% p(6).Marker = '+';
% p(7).Marker = 'o';
% p(8).Marker = 'square';
% p(9).Marker = 'x';

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


%% ITAE vs Ps with fsw max (worst case switching)
figure;

subplot(1,2,1);
p = plot([.1 .2 .3 .4 .5 .6],set_itae_bl_and_ft_f_max', ':.', 'LineWidth', 3, 'MarkerSize', 8); 
grid on; grid minor;
xlabel('P_s [probability]');
ylabel('ITAE [radians]');    

p(1).Marker = '.';
p(2).Marker = '*';
p(3).Marker = 'hexagram';
p(4).Marker = '>';
% p(5).Marker = '<';
% p(6).Marker = '+';
% p(7).Marker = 'o';
% p(8).Marker = 'square';
% p(9).Marker = 'x';

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

subplot(1,2,2);
p = plot([.1 .2 .3 .4 .5 .6],set_itae_bl_and_ft_f_min', ':.', 'LineWidth', 3, 'MarkerSize', 8); 
grid on; grid minor;
xlabel('P_s [probability]');
ylabel('ITAE [radians]');

p(1).Marker = '.';
p(2).Marker = '*';
p(3).Marker = 'hexagram';
p(4).Marker = '>';
% p(5).Marker = '<';
% p(6).Marker = '+';
% p(7).Marker = 'o';
% p(8).Marker = 'square';
% p(9).Marker = 'x';

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

 