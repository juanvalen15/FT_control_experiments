% compare_compsoc_simulink

data_compsoc                 = csvread('app_fault_tolerance.parsed');
data_compsoc_control         = csvread('app_fault_tolerance_control.parsed');
data_compsoc_sa_instants     = csvread('sa_instants.parsed');
    
msize = 10;
lwidth = 1;

samples = 2000;



%%
figure;

subplot(1,2,1);
plot(sensed_data_x1.Time, ws_reference.Data, 'LineStyle','--','color','k'); hold on;
plot(sensed_data_x1.Time, sensed_data_x1.Data, 'b*-'); hold on;
plot(sensed_data_x1.Time, data_compsoc(:,2), 'ro-', 'MarkerSize',8);hold on; 

HL = legend('Reference','MATLAB','HIL');
HX = xlabel('Time [s]');
HY = ylabel('System Output [radians]');

xlim([0 0.7]);
grid on;


set(gca,'fontsize',11)
set(HX,'FontSize', 14);
set(HY,'FontSize', 14);
set(HL,'Fontsize',12)

% export_fig(['HIL_system_output.pdf'], '-pdf','-transparent');


subplot(1,2,2);

hil_error = abs(sensed_data_x1.Data - data_compsoc(:,2));
plot(sensed_data_x1.Time, hil_error, 'ro-', 'MarkerSize',8);hold on; 

HX = xlabel('Time [s]');
HY = ylabel('Error [radians]');

xlim([0 0.7]);
grid on;


set(gca,'fontsize',11)
set(HX,'FontSize', 14);
set(HY,'FontSize', 14);
set(HL,'Fontsize',12)

% export_fig(['HIL_system_output_error.pdf'], '-pdf','-transparent');





%%
figure;

subplot(2,2,1);
plot(data_compsoc(:,2),'r:.', 'linewidth',lwidth,'markersize',msize);hold on; 
plot(ws_reference.Data,'b', 'linewidth', lwidth, 'markersize', msize); 
plot(sensed_data_x1.Data,'c:.', 'linewidth', lwidth, 'markersize', msize);
legend('compsoc mechanism','reference','simulink');
xlabel('time [clock cycles]');
ylabel('x1 [rad]');
xlim([0 samples]);
grid on;

subplot(2,2,2);
plot(data_compsoc(:,3),'r:.', 'linewidth',lwidth,'markersize',msize);hold on; 
plot(ws_reference.Data,'b', 'linewidth', lwidth, 'markersize', msize); 
plot(sensed_data_x2.Data,'c:.', 'linewidth', lwidth, 'markersize', msize);
legend('compsoc mechanism','reference','simulink');
xlabel('time [clock cycles]');
ylabel('x2 [rad]');
xlim([0 samples]);
grid on;

subplot(2,2,3);
plot(data_compsoc(:,4),'r:.', 'linewidth',lwidth,'markersize',msize);hold on;  
plot(sensed_data_x3.Data,'c:.', 'linewidth', lwidth, 'markersize', msize);
legend('compsoc mechanism','reference','simulink');
xlabel('time [clock cycles]');
ylabel('omega1 [rad/s]');
xlim([0 samples]);
grid on;


subplot(2,2,4);
plot(data_compsoc(:,5),'r:.', 'linewidth',lwidth,'markersize',msize);hold on; 
plot(sensed_data_x4.Data,'c:.', 'linewidth', lwidth, 'markersize', msize);
legend('compsoc mechanism','reference','simulink');
xlabel('time [clock cycles]');
ylabel('omega2 [rad/s]');
xlim([0 samples]);
grid on;


%%
figure;
plot(data_compsoc_control(:,2),'r:.', 'linewidth',lwidth,'markersize',msize);hold on; 
plot(actuation_signal.Data,'c:.', 'linewidth', lwidth, 'markersize', msize);
legend('compsoc mechanism','simulink');
xlabel('time [clock cycles]');
ylabel('actuation signal [A]');
xlim([0 samples]);
grid on;


%%
figure;
subplot(2,1,1);
plot(data_compsoc_sa_instants(:,2),'r:.', 'linewidth',lwidth,'markersize',msize);hold on; 
plot(ws_sensing_instant.Data,'c:.', 'linewidth', lwidth, 'markersize', msize);
legend('compsoc mechanism','simulink');
ylim([-1 2]);
xlabel('time [clock cycles]');
ylabel('sensing instanat [0/1]');
xlim([0 samples]);
grid on;


%%
subplot(2,1,2);
plot(data_compsoc_sa_instants(:,3),'r:.', 'linewidth',lwidth,'markersize',msize);hold on; 
plot(ws_actuation_instant.Data,'c:.', 'linewidth', lwidth, 'markersize', msize);
legend('compsoc mechanism','simulink');
ylim([-1 2]);
xlabel('time [clock cycles]');
ylabel('actuation instanat [0/1]');
xlim([0 samples]);
grid on;