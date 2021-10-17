% ploting pynqserver results with matlab

% read pynq results
pynqcontroloutput = readtable('../ft_journal_pynq/FT_app_workspace/FT_app_v4-paper-results/control_output_PF_0P1.txt');
load control_output_PF_0P1_MATLAB.mat;

% read matlab results
samples=1000;
FLOAT_TO_INT = 100000;

figure;

subplot(2,2,1)
plot(k.data(1:samples), r_out.data(1:samples), 'r',...
     k.data(1:samples),  z.data(1:samples,1), 'b:.', ...
     k.data(1:samples), pynqcontroloutput.s0(1:samples)/FLOAT_TO_INT, 'c:.')
xlim([0 100]);
xlabel('k [samples]');
ylabel('\theta_1 [rad]');
legend('reference','MATLAB', 'CompSoC');
title('P_s = 0.1')
grid on;

subplot(2,2,3)
area(k.data(1:samples), m.data(1:samples))
xlim([0 100]);
xlabel('k [samples]');
ylabel('m');
grid on;


pynqcontroloutput = readtable('../ft_journal_pynq/FT_app_workspace/FT_app_v4-paper-results/control_output_PF_0P5.txt');
load control_output_PF_0P5_MATLAB.mat;

subplot(2,2,2)
plot(k.data(1:samples), r_out.data(1:samples), 'r',...
     k.data(1:samples),  z.data(1:samples,1), 'b:.', ...
     k.data(1:samples), pynqcontroloutput.s0(1:samples)/FLOAT_TO_INT, 'c:.')
xlim([600 900]);
xlabel('k [samples]');
ylabel('\theta_1 [rad]');
legend('reference','MATLAB', 'CompSoC');
title('P_s = 0.5')
grid on;

subplot(2,2,4)
area(k.data(1:samples), m.data(1:samples))
xlim([600 900]);
xlabel('k [samples]');
ylabel('m');
grid on;

% % ploting pynqserver results with matlab
% 
% % read pynq results
% pynqcontroloutput = readtable('../ft_journal_pynq/FT_app_workspace/FT_app_v4-paper-results/control_output_PF_0P1.txt');
% load control_output_PF_0P1_MATLAB.mat;
% 
% % read matlab results
% samples=1000;
% FLOAT_TO_INT = 100000;
% 
% figure;
% 
% subplot(5,2,1)
% plot(k.data(1:samples), r_out.data(1:samples), 'r',...
%      k.data(1:samples),  z.data(1:samples,1), 'b:.', ...
%      k.data(1:samples), pynqcontroloutput.s0(1:samples)/FLOAT_TO_INT, 'c:.')
% xlabel('k [samples]');
% ylabel('\theta_1 [rad]');
% legend('reference','MATLAB', 'CompSoC');
% grid on;
% 
% 
% subplot(5,2,3)
% plot(k.data(1:samples), r_out.data(1:samples), 'r',...
%      k.data(1:samples),  z.data(1:samples,2), 'b:.', ...
%      k.data(1:samples), pynqcontroloutput.s1(1:samples)/FLOAT_TO_INT, 'c:.')
% xlabel('k [samples]');
% ylabel('\theta_2 [rad]');
% legend('reference','MATLAB', 'CompSoC');
% grid on;
% 
% subplot(5,2,5)
% plot(k.data(1:samples), r_out.data(1:samples), 'r',...
%      k.data(1:samples),  z.data(1:samples,3), 'b:.', ...
%      k.data(1:samples), pynqcontroloutput.s2(1:samples)/FLOAT_TO_INT, 'c:.')
% xlabel('k [samples]');
% ylabel('\omega_1 [rad]');
% legend('reference','MATLAB', 'CompSoC');
% grid on;
% 
% 
% subplot(5,2,7)
% plot(k.data(1:samples), r_out.data(1:samples), 'r',...
%      k.data(1:samples),  z.data(1:samples,4), 'b:.', ...
%      k.data(1:samples), pynqcontroloutput.s3(1:samples)/FLOAT_TO_INT, 'c:.')
% xlim([0 100]); 
% xlabel('k [samples]');
% ylabel('\omega_2 [rad]');
% legend('reference','MATLAB', 'CompSoC');
% grid on;
% 
% 
% subplot(5,2,9)
% area(k.data(1:samples), m.data(1:samples))
% xlabel('k [samples]');
% ylabel('m');
% grid on;




