%% CONTROLLER GAINS: FEEDBACK AND FEEDFORWARD GAINS FOUND USING PSO + LQR

K_total = [];
F_total = [];
for i = 1:control_modes
   load(['../controllers_per_mode/exp_journal/script_based/output/controllers/C-BEST-MODE-' num2str(i) '.mat'])
   K_total = [K_total; K]; 
   F_total = [F_total; F];
end