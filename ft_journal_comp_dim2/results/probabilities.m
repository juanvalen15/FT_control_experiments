%% probability statistics

clear modes pe pr

pe = linspace(0.0001, 0.9999, 10000);
pr = linspace(0.8000, 0.9999, 10000);
f  = [1 4 4];

for pr_index = 1:length(pr)
    for pe_index = 1:length(pe)
        modes(pr_index, pe_index) = ceil( max( log(log(1-((pr(pr_index))^1/f(3)))/log(pe(pe_index)))/log(2), 1 ) );
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
a1 = plot(pe, modes(samples_y1,:)', '-.','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10); 
a2 = plot(pe, modes(samples_y2,:)', 'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor',[.49 1 .63],'MarkerSize',10);
xlabel('P_f'); ylabel('Number of operational modes n'); grid on; hold on
legend([a1 a2],{ sprintf('P_r = %0.4f', pr(samples_y1)), ...
                 sprintf('P_r = %0.4f', pr(samples_y2)) } );

% for pe_index = 1:length(pe)
%     pr(pe_index) = ( 1 - (pe(pe_index)^(2^m)) )^f(3);
% end
% figure;
% plot(pe,pr,'r:.');
% xlabel('pe'); ylabel('pr'); grid on;

