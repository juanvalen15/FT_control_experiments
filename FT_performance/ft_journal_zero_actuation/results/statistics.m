%% RUN STATISTICS: EVALUATES THE SYSTEM OUTPUT ERRORS WHILE VARYING THE ERROR PROBABILITY

mean_e1_array = [];
mean_e2_array = [];
mean_e3_array = [];

pe_vector = [];

for pe = 0:0.04:0.8

    error_probability = pe;
    
    %% CALLING FRAMEWORKS
    main_PSO;
    main_FT;
    
    %% COMPARISONS
    compare_pso_ft_traces;

    mean_e1_array = [mean_e1_array mean_e1];
    mean_e2_array = [mean_e2_array mean_e2];
    mean_e3_array = [mean_e3_array mean_e3];
    
    pe_vector = [pe_vector pe];
    
    %% closing figures per iteration
    close all;    
end


%% MEAN ERROR
pe = pe_vector;
samples = length(pe);

figure;
hold on; grid on;
title('System output mean absolute error'); xlabel('Error probability'); ylabel('mean absolute error [radians]'); 
p1 = plot(pe(1:samples), mean_e1_array(1:samples), 'r:.');
p2 = plot(pe(1:samples), mean_e2_array(1:samples), 'g:.');
p3 = plot(pe(1:samples), mean_e3_array(1:samples), 'b:.');
legend([p1 p2 p3], ...
      { sprintf('Mean abs. error: sys. output with error injection with FT mechanism. EXP: %d', controller_experiment), ...
        sprintf('Mean abs. error: sys. output without error injection and no FT mechanism. EXP: %d MODE: %d', controller_experiment, controller_mode), ...
        sprintf('Mean abs. error: sys. output with error injection without FT mechanism. EXP: %d MODE: %d', controller_experiment, controller_mode)
      });
  
save('results\results_probabilities.mat', ...
     'mean_e1_array', 'mean_e2_array', 'mean_e3_array', 'pe');  
  
  