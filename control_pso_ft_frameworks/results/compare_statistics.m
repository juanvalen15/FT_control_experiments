%% COMPARING RESULTS FROM STATISTICS WITH DIFFERENT MODES

%% START
fprintf('\n Plotting statistic results \n')

%% LOAD RESULTS
load('results_probabilities_mode_1.mat');
mean_e1_m1 = mean_e1_array;
mean_e2_m1 = mean_e2_array;
mean_e3_m1 = mean_e3_array;
pe_m1      = pe;

load('results_probabilities_mode_2.mat');
mean_e1_m2 = mean_e1_array;
mean_e2_m2 = mean_e2_array;
mean_e3_m2 = mean_e3_array;
pe_m2      = pe;

load('results_probabilities_mode_3.mat');
mean_e1_m3 = mean_e1_array;
mean_e2_m3 = mean_e2_array;
mean_e3_m3 = mean_e3_array;
pe_m3      = pe;


%% 
figure;

samples = length(pe_m1); % check this length
% samples = 18; % check this length

% mode 1
sb1 = subplot(3,1,1); hold on; grid on;
title(sprintf('mean sys. output error. EXP: %d MODE: %d', controller_experiment, 1)); 
xlabel('error probability'); ylabel('mean absolute error [radians]'); 
p1 = plot(pe(1:samples), mean_e1_m1(1:samples), 'r:.', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
p2 = plot(pe(1:samples), mean_e2_m1(1:samples), 'g:.', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
p3 = plot(pe(1:samples), mean_e3_m1(1:samples), 'b:.', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
xlim([0 0.7]); ylim([0 1.2]);
legend([p1 p2 p3], ...
      { sprintf('Mean abs. error: sys. output with error injection with FT mechanism. EXP: %d', controller_experiment), ...
        sprintf('Mean abs. error: sys. output without error injection and no FT mechanism. EXP: %d MODE: %d', controller_experiment, 1), ...
        sprintf('Mean abs. error: sys. output with error injection without FT mechanism. EXP: %d MODE: %d', controller_experiment, 1)
      });


% mode 2
sb2 = subplot(3,1,2); hold on; grid on;
title(sprintf('mean sys. output error. EXP: %d MODE: %d', controller_experiment, 2)); 
xlabel('error probability'); ylabel('mean absolute error [radians]'); 
p1 = plot(pe(1:samples), mean_e1_m2(1:samples), 'r:.', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
p2 = plot(pe(1:samples), mean_e2_m2(1:samples), 'g:.', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
p3 = plot(pe(1:samples), mean_e3_m2(1:samples), 'b:.', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
xlim([0 0.7]); ylim([0 1.2]);
legend([p1 p2 p3], ...
      { sprintf('Mean abs. error: sys. output with error injection with FT mechanism. EXP: %d', controller_experiment), ...
        sprintf('Mean abs. error: sys. output without error injection and no FT mechanism. EXP: %d MODE: %d', controller_experiment, 2), ...
        sprintf('Mean abs. error: sys. output with error injection without FT mechanism. EXP: %d MODE: %d', controller_experiment, 2)
      });
  
% mode 3
sb3 = subplot(3,1,3); hold on; grid on;
title(sprintf('mean sys. output error. EXP: %d MODE: %d', controller_experiment, 3)); 
xlabel('error probability'); ylabel('mean absolute error [radians]'); 
p1 = plot(pe(1:samples), mean_e1_m3(1:samples), 'r:.', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
p2 = plot(pe(1:samples), mean_e2_m3(1:samples), 'g:.', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
p3 = plot(pe(1:samples), mean_e3_m3(1:samples), 'b:.', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
xlim([0 0.76]); ylim([0 1.2]);
legend([p1 p2 p3], ...
      { sprintf('Mean abs. error: sys. output with error injection with FT mechanism. EXP: %d', controller_experiment), ...
        sprintf('Mean abs. error: sys. output without error injection and no FT mechanism. EXP: %d MODE: %d', controller_experiment, 3), ...
        sprintf('Mean abs. error: sys. output with error injection without FT mechanism. EXP: %d MODE: %d', controller_experiment, 3)
      });  

% linkaxes([sb1 sb2 sb3],'x'); % add markers to the graphs

%% mean error interesting part
figure;
samples = length(pe_m1); % check this length

% mode 1
hold on; grid on;
p1 = plot(pe(1:samples), mean_e1_m1(1:samples),'-','MarkerSize',8,'Color',colorspec{1},'Marker', markerspec{1});
p2 = plot(pe(1:samples), mean_e3_m1(1:samples),'-','MarkerSize',8,'Color',colorspec{2},'Marker', markerspec{2});    
p3 = plot(pe(1:samples), mean_e3_m2(1:samples),'-','MarkerSize',8,'Color',colorspec{3},'Marker', markerspec{3});    
p4 = plot(pe(1:samples), mean_e3_m3(1:samples),'-','MarkerSize',8,'Color',colorspec{4},'Marker', markerspec{5});    
xlim([0 0.8]); ylim([0 1.5]);
xlabel('error probability'); ylabel('mean absolute error [radians]'); 
legend([p1 p2 p3 p4], ...
      { 'error injection with fault-tolerant mechanism', ...
        'error injection without fault-tolerant mechanism: mode 1', ...
        'error injection without fault-tolerant mechanism: mode 2' ...
        'error injection without fault-tolerant mechanism: mode 3'
      });


%% results comparison
figure;
hold on; grid on;
% title('mean sys. output error'); 
xlabel('error probability'); ylabel('mean absolute error [radians]'); 
p1 = plot(pe(1:samples), mean_e1_m3(1:samples), 'r:.', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
p2 = plot(pe(1:samples), mean_e3_m3(1:samples), 'b:.', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
l1 = line([0.32 0.32], [0 2],'Color', [0.1 0.6 0.6],'LineStyle','-.','LineWidth',2);
l2 = line([0.6 0.6], [0 2],'Color', [0.3 0.8 0.2],'LineStyle','--','LineWidth',2);
l3 = line([0.68 0.68], [0 2],'Color', [0.5 0.1 0.3],'LineStyle','-.','LineWidth',2);
xlim([0 0.76]); ylim([0.4 1.4]);
legend([p1 p2 l1 l2 l3], ...
      { 'mean absolute error for system with fault-tolerant mechanism', ...
        'mean absolute error for system without fault-tolerant mechanism - baseline mode 3', ...
        sprintf('maximum error probability for a reliability of %0.4f', (1 - 0.32^8) ), ...
        sprintf('maximum error probability for a reliability of %0.4f', (1 - 0.6^8) ), ...
        sprintf('maximum error probability for a reliability of %0.4f', (1 - 0.68^8) )
      });  

fprintf('Done \n');


%% PLOT MAX. CONSECUTIVE ERRORS VS. INJECTED ERROR PROBABILITY
load('results_errors_and_probabilities.mat');

% non_faulty_data = max_errors_array(1:28);
% non_faulty_pe   = pe(1:28);
% 
% figure; 
% 
% a1 = area(pe, max_errors_array'); hold on
% xlabel('error probability'); ylabel('max. number of errors'); grid on;
% set(a1, 'FaceColor', [.2 .2 .7]);
% 
% a2 = area(non_faulty_pe, non_faulty_data'); hold on
% xlabel('error probability'); ylabel('max. number of errors'); grid on;
% set(a2, 'FaceColor', [.7 .2 .2]);
% 
% legend([a1 a2],{'Faulty region','Non-faulty region'});


%% PLOTING SURFACE FOR MODES VARIATION DUE TO ERROR PROBABILITY AND RELIABILITY
% pr = linspace(0.01, 0.9999, length(pe));
pr = linspace(0.1, 0.9, length(pe));

for pr_index = 1:length(pr)
    for pe_index = 1:length(pe)
        modes(pr_index, pe_index) = ceil( max( log(log(1-pr(pr_index))/log(pe(pe_index)))/log(2), 1 ) );
    end
end

%%
figure;
samples_y1 = 9; 
samples_y2 = 7;

a1 = stairs(pe, modes(samples_y1,:)', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10); 
xlabel('error probability'); ylabel('min. number of modes'); grid on; hold on;
a2 = stairs(pe, modes(samples_y2,:)', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
xlabel('error probability'); ylabel('min. number of modes'); grid on; hold on
legend([a1 a2],{ sprintf('reliability probability = %0.4f', pr(samples_y1)), ...
                 sprintf('reliability probability = %0.4f', pr(samples_y2)) } );

%%
figure;
surf(pe,pr,modes);
xlabel('error probability'); ylabel('reliability probability'); zlabel('min. number of modes'); grid on;

%%
figure;
pe1 = 2;
pe2 = 4;
pe3 = 6;
pe4 = 8;
h1 = histogram( cnt_array_cell{pe1} ); hold on;
h2 = histogram( cnt_array_cell{pe2} ); hold on;
h3 = histogram( cnt_array_cell{pe3} ); hold on;
h4 = histogram( cnt_array_cell{pe4} ); hold on;
legend([h1 h2 h3 h4], ...
        {sprintf('Pe_{1} = %0.4f', pe(pe1)), ...
         sprintf('Pe_{2} = %0.4f', pe(pe2)), ...
         sprintf('Pe_{3} = %0.4f', pe(pe3)), ...
         sprintf('Pe_{4} = %0.4f', pe(pe4)) ...
         });
xlabel('number of consecutive errors'); ylabel('number of ocurrences in 10000 executions'); 
grid on; hold on



%% finding pe instead
pr_new = linspace(0.0001, 0.9999, 10000);
m  = 1:10;

m_index = 1;

for pr_index = 1:length(pr_new)
    for m_index = 1:length(m)
        pe_new(pr_index, m_index) = ( 1 - pr_new(pr_index) )^( 1/(2^m(m_index)) ) ;
    end
end

% figure;
% surf(m,pr_new,pe_new);
% xlabel('modes'); ylabel('pr'); zlabel('pe'); grid on;


figure;
p1 = plot(pr_new, pe_new(:,1),'Color',colorspec{1},'MarkerSize', Makersize, 'Marker', markerspec{1}); hold on;
p2 = plot(pr_new, pe_new(:,2),'Color',colorspec{2},'MarkerSize', Makersize, 'Marker', markerspec{2}); hold on;         
p3 = plot(pr_new, pe_new(:,3),'Color',colorspec{3},'MarkerSize', Makersize, 'Marker', markerspec{3}); hold on;         
p4 = plot(pr_new, pe_new(:,4),'Color',colorspec{4},'MarkerSize', Makersize, 'Marker', markerspec{4}); hold on;
% p5 = plot(pr_new, pe_new(:,5),'Color',colorspec{5},'MarkerSize', Makersize, 'Marker', markerspec{1}); hold on;
% p6 = plot(pr_new, pe_new(:,6),'Color',colorspec{6},'MarkerSize', Makersize, 'Marker', markerspec{1}); hold on;
% p7 = plot(pr_new, pe_new(:,7),'Color',colorspec{7},'MarkerSize', Makersize, 'Marker', markerspec{1}); hold on;
% p8 = plot(pr_new, pe_new(:,8),'Color',colorspec{8},'MarkerSize', Makersize, 'Marker', markerspec{1}); hold on;
% p9 = plot(pr_new, pe_new(:,9),'Color',colorspec{9},'MarkerSize', Makersize, 'Marker', markerspec{1}); hold on;
% p10 = plot(pr_new, pe_new(:,10),'Color',colorspec{10},'MarkerSize', Makersize, 'Marker', markerspec{1}); hold on;
xlabel('reliability probability'); ylabel('max. allowed error probability'); grid on; hold on;
legend([p1 p2 p3 p4],{ 'mode = 1','mode = 2','mode = 3','mode = 4' } );

