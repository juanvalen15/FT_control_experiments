%% probability given  execution failing number
clearvars -global; clearvars; close all; clc;

pe = linspace(0.0001, 0.9999, 10000);
pr = linspace(0.8000, 0.9999, 10000);

for pr_index = 1:length(pr)
    for pe_index = 1:length(pe)
        fe_prpe(pr_index, pe_index) = log(1 - pr(pr_index))/log(pe(pe_index));
    end
end

% figure;
% surf(pe,pr,modes);
% xlabel('error probability'); ylabel('reliability probability'); zlabel('min. number of modes'); grid on;

%%
figure;
samples_y1 = 1; 
samples_y2 = 9999;

hold on;
a1 = plot(pe, ceil(fe_prpe(samples_y1,:)'), 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10); 
a2 = plot(pe, ceil(fe_prpe(samples_y2,:)'), 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
xlim([0 1]); ylim([0 30]);
xlabel('P_e'); ylabel('required number of executions'); grid on; hold on
legend([a1 a2],{ sprintf('P_r = %0.4f', pr(samples_y1)), ...
                 sprintf('P_r = %0.4f', pr(samples_y2)) } );


