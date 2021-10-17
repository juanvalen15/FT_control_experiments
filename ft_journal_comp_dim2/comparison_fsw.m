clear all;
close all;

pf_array = 0.1:0.01:0.9;

%% loading data
for i = 1:200
    for j = 1:length(pf_array)
        load (['results_from_ft_framework' num2str(i) '_Pf_' num2str(pf_array(j)) '.mat']); 

        e1 = reference_output.Data-sensed_data_x1.Data; 
        e2 = reference_output.Data-sensed_data_x1_fixed.Data; 

        me1(i,j) = mean(abs(e1));
        me2(i,j) = mean(abs(e2));
    end
end


%% ploting data
pf1=1;
pf2=50;
pf3=80;

figure;
semilogy(me1(:,[pf1 pf2 pf3]), ':.');
grid on;
legend(['P_f= ' num2str(pf_array(pf1))],['P_f= ' num2str(pf_array(pf2))],['P_f= ' num2str(pf_array(pf3))]);
xlabel('f_{sw}');
HY=ylabel('|$$\overline{e}$$|');
set(HY,'interpreter','latex');