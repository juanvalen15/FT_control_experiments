% script to present mae results

%% clear
clear all;
close all;
clc;

%% load data
load mae_results_n_2_to_10.mat

%% arrange data
BS_n  = BS_mae(1:7);

FT_n2 = FT_mae(8:14);
FT_n3 = FT_mae(15:21);
FT_n4 = FT_mae(22:28);
FT_n5 = FT_mae(29:35);
FT_n6 = FT_mae(36:42);
FT_n7 = FT_mae(43:49);
FT_n8 = FT_mae(50:56);
FT_n9 = FT_mae(57:63);

RESULTS = [BS_n, FT_n2 FT_n3 FT_n4 FT_n5 FT_n6 FT_n7 FT_n8 FT_n9];

Ps_n = Ps(1:7);




%% plots
figure;
p = semilogy(RESULTS, ':.'); 
grid on; grid minor;


p(1).Marker = '.';
p(2).Marker = '*';
p(3).Marker = 'hexagram';
p(4).Marker = '>';
p(5).Marker = '<';
p(6).Marker = '+';
p(7).Marker = 'o';
p(8).Marker = 'square';
p(9).Marker = 'x';



legend('Baseline n=1', ...
       'n=2 | FT with f=[2 2]', ...
       'n=3 | FT with f=[1 1 2]', ...
       'n=4 | FT with f=[1 3 2 3]', ...
       'n=5 | FT with f=[1 3 2 2 3]', ...
       'n=6 | FT with f=[1 1 2 2 3 3]', ...
       'n=7 | FT with f=[1 1 3 2 3 2 3]', ...
       'n=8 | FT with f=[1 1 2 2 2 3 3 3]', ...
       'n=9 | FT with f=[1 1 2 2 2 2 3 2 3]');










