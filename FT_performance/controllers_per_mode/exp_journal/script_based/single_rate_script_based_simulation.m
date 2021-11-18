%% Control loop simulation 
% By Juan Valencia

function [x, u, time] = single_rate_script_based_simulation(plot_on_off, delay_on_off, simulation_time, reference, sampling_period, A, B, K, F)

% Pattern and sampling periods
allocationPattern = 1;
sampling_periods = sampling_period;

% LOOP
% Initial values: based on length of A: 4x4 matrix
x    = [0 0; 0 0; 0 0; 0 0];
u    = [0 0];
time = [0 0];

index = 2; 

for k = 1:round( simulation_time/sampling_period ) % times allocation pattern length    
    for j = 1:length(allocationPattern)   
        sys = allocationPattern(j);
        if j==1
            if delay_on_off == 1
                u(:,index) = K{sys}*[x(:,index); u(:,index-1)] + F{sys}*reference;       
                xkp1 = A*[x(:,index); u(:,index-1)] + B*u(:,index);
            else
                u(:,index) = K{sys}*x(:,index) + F{sys}*reference;       
                xkp1 = A*x(:,index) + B*u(:,index);
            end
            time(index) = time(index-1) + sampling_periods(sys);
        else
            if delay_on_off == 1
                u(:,index+j-1) = K{sys}*[x(:,index+j-1); u(:,index+j-2)] + F{sys}*reference;           
                xkp1 = A*[x(:,index+j-1); u(:,index+j-2)] + B*u(:,index+j-1);  
            else
                u(:,index+j-1) = K{sys}*x(:,index+j-1) + F{sys}*reference;           
                xkp1 = A*x(:,index+j-1) + B*u(:,index+j-1);  
            end
            time(index+j-1) = time(index+j-2) + sampling_periods(sys);
        end        
        x(:, index+j) = xkp1(1:4,1);                    
    end    
    index = index + j;           
end     




% PLOTS
if plot_on_off == 1
    figure;
    title('single-rate simulation');

    sb1 = subplot(2,1,1);
    plot(time(1:end-1), x(1,2:end-1), 'b:.');
    grid on;
    xlabel('time [s]');
    ylabel('system output [rad]');

    sb2 = subplot(2,1,2);
    plot(time(1:end-1), u(1,1:end-1), 'b:.');
    grid on;
    xlabel('time [s]');
    ylabel('control input [A]');

    linkaxes([sb1 sb2],'x'); % add markers to the graphs
end

end