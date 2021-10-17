%% MR simulation
% By Juan Valencia
% 27.06.2018

% function [x, u, time] = mr_sim(plot_on_off, simulation_time, reference, sampling_periods, allocationPattern, sp_sequence_s, A, B, K, F)
%%
load (['output/results/exp' num2str(2) '/LQR_LPTV/ControlMatrices_set_1.mat']); % always load the same files
load (['output/results/exp' num2str(2) '/LQR_LPTV/SysMatrices_set_1.mat']) % always load the same files

dim = 4;

C_aug{1} = [1 0 0 0 0];
C_aug{2} = [1 0 0 0 0];

simulation_time = 50;

clear K F;
CL_PROD = eye(dim+1,dim+1); % closed-loop product
for i = 1:length(Ks)
    K{i}  = -Ks{i};
    Cs{i} = C_aug{1};
    F{i}  = inv( Cs{i} / ( eye(dim+1) - As{i} - (Bs{i}*K{i}) ) * Bs{i}); % feedforward gain
    
    CL_PROD = CL_PROD * (As{i} + Bs{i}*K{i});
end

%%
% LOOP
% Initial values: based on length of A: 4x4 matrix
x    = [0 0; 0 0; 0 0; 0 0];
u    = [0 0];
time = [0 0];

index = 2;

for k = 1:round( simulation_time/sum(sp_sequence_s) ) % times allocation pattern length
    for j = 1:length(allocationPattern)
        sys = allocationPattern(j);
        if j==1
            u(:,index) = K{sys}*[x(:,index); u(:,index-1)] + F{sys}*reference;
            xkp1 = A{sys}*[x(:,index); u(:,index-1)] + B{sys}*u(:,index);
            time(index) = time(index-1) + sampling_periods(sys);
        else
            u(:,index+j-1) = K{sys}*[x(:,index+j-1); u(:,index+j-2)] + F{sys}*reference;
            xkp1 = A{sys}*[x(:,index+j-1); u(:,index+j-2)] + B{sys}*u(:,index+j-1);
            time(index+j-1) = time(index+j-2) + sampling_periods(sys);
        end
        x(:, index+j) = xkp1(1:4,1);
    end
    index = index + j;
end




% PLOTS
% if plot_on_off == 1
%     figure;
%     title('multi-rate simulation');
%     
%     sb1 = subplot(2,1,1);
%     plot(time(1:end-1), x(1,2:end-1), 'b:.');
%     grid on;
%     xlabel('time [s]');
%     ylabel('system output [rad]');
%     
%     sb2 = subplot(2,1,2);
%     plot(time(1:end-1), u(1,1:end-1), 'b:.');
%     grid on;
%     xlabel('time [s]');
%     ylabel('control input [A]');
%     
%     linkaxes([sb1 sb2],'x'); % add markers to the graphs
% end
% end