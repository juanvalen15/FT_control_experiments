%% Simulation: matlab script simulation for switching control with reliability consideration

for loop_ref=1:2
%% reference matrix
    if loop_ref==1
        ref=[reference_profile -reference_profile reference_profile];
    elseif loop_ref==2
        ref=[reference_profile reference_profile reference_profile];
    end
r_n = 1;
for r_iter = 1:(length(ref)*(5/min(period_s))) %change every 5 seonds
    if (r_iter<=((5/min(period_s)*r_n)))
        refer(r_iter) = ref(r_n);
    else
        r_n = r_n+1;
        refer(r_iter) = ref(r_n);
    end
    time_r(r_iter) = min(period_s)*(r_iter-1);
end

for r_n = 1:(size(ref,2)-1)
    refer=[refer(1:(5/min(period_s)*r_n)+r_n-1), ref(r_n), refer((5/min(period_s)*r_n)+r_n:end)];
    time_r=[time_r(1:(5/min(period_s)*r_n)+r_n-1), time_r((5/min(period_s)*r_n)+r_n), time_r((5/min(period_s)*r_n)+r_n:end)];
end
%% y_L, input and psd plots
clear x1 x2 x3 x4 input y_L time xkp1 x30 input0;
for loop = 1:2

timingPattern=timingPattern_init(loop,:);

x1(1) = 0.0;
x2(1) = 0.0;
x4(1) = 0.0;
x3(1) = 0.0;
input(1) = 0;
y_L(1) = 0;
time(1) = 0;

x1_mjls(1) = 0.0;
x2_mjls(1) = 0.0;
x4_mjls(1) = 0.0;
x3_mjls(1) = 0.0;
input_mjls(1) = 0;
y_L_mjls(1) = 0;

mse_reference(1)=0;
extra = 1;
count = 0;
for i=1:length(timingPattern)
    count = count+timingPattern(i);
    if (mod(5,count)==0)
        extra = 0;
    end
end

i=1;i_n=1; iter_j = length(timingPattern);
for ref_n=1:length(ref)
    r=ref(ref_n);
    while time(i) <= i_n*5
        reset = 0;
    for j=1:iter_j
            if loop==1 
               Sys = get_sample_mc(P_markov,1);
%                 Sys = timingPattern(j);
            elseif loop==2
                Sys = get_sample_mc(P_markov,Sys);
%                  Sys = timingPattern(j);
            end
            
            if (((time(i) + period_s(Sys))> i_n*5) && (time(i)<(i_n*5-(min(period_s)/100))))
                reset = 1;
                x1(i+1) = x1(i);
                x2(i+1) = x2(i);
                x3(i+1) = x3(i);
                x4(i+1) = x4(i);
                input(i+1) = input(i);
                y_L(i+1) = C_aug{Sys}*[x1(i);x2(i);x3(i);x4(i);input(i)];
                
                x1_mjls(i+1) = x1_mjls(i);
                x2_mjls(i+1) = x2_mjls(i);
                x3_mjls(i+1) = x3_mjls(i);
                x4_mjls(i+1) = x4_mjls(i);
                input_mjls(i+1) = input_mjls(i);
                y_L_mjls(i+1) = C_aug{Sys}*[x1_mjls(i);x2_mjls(i);x3_mjls(i);x4_mjls(i);input_mjls(i)];
                              
                time(i+1) = i_n*5;
                mse_reference(i+1)=r;
                i = i+1;
                break;
            end
            if(time(i)+period_s(Sys)>i_n*5)
                reset = 1;
                break;
            end      
            if i==1
                U = K{Sys}*[x1(i);x2(i);x3(i);0];
                xkp1 = phi_aug{Sys}*[x1(i);x2(i);x3(i);0] + Gamma_aug{Sys}*U;
                
                U_mjls = K_gain{Sys}*[x1_mjls(i);x2_mjls(i);x3_mjls(i);0];
                xkp1_mjls = phi_aug{Sys}*[x1_mjls(i);x2_mjls(i);x3_mjls(i);0] + Gamma_aug{Sys}*U_mjls;
            else
                U = K{Sys}*[x1(i);x2(i);x3(i);input(i-1)] + F{Sys}*r;
                xkp1 = phi_aug{Sys}*[x1(i);x2(i);x3(i);input(i-1)] + Gamma_aug{Sys}*U;
                
                U_mjls = K_gain{Sys}*[x1_mjls(i);x2_mjls(i);x3_mjls(i);input_mjls(i-1)] - Forward_gain{Sys}*r;
                xkp1_mjls = phi_aug{Sys}*[x1_mjls(i);x2_mjls(i);x3_mjls(i);input_mjls(i-1)] + Gamma_aug{Sys}*U_mjls;
            end
            
            x1_mjls(i+1) = xkp1_mjls(1);
            x2_mjls(i+1) = xkp1_mjls(2);
            x3_mjls(i+1) = xkp1_mjls(3);
            input_mjls(i+1) = U_mjls;
            y_L_mjls(i+1) = C_aug{Sys}*xkp1_mjls;
            
            x1(i+1) = xkp1(1);
            x2(i+1) = xkp1(2);
            x3(i+1) = xkp1(3);
            input(i+1) = U;
            y_L(i+1) = C_aug{Sys}*xkp1;

            time(i+1) = time(i) + period_s(Sys);
            mse_reference(i+1)=r;

            i=i+1;
        end
        j=1;
        iter_j = length(timingPattern);
        
        if (reset==1)
            break;
        end
            
    end
    j=1;
    i_n=i_n+1;
%     if ref_n==1
%         xx_init=stepinfo(x3,time,r)
%     end
end

i=1;i_n=1;
%clear xkp1;

%% store data
    if loop==1
%         if CQLF_stable==1
            x30{loop} = y_L;%x3;
            input0{loop} = input;
%         else
%             x30{loop} = 0;%x3;
%             input0{loop} = 0;
%         end
        x30_mjls{loop} = y_L_mjls;%x3;
        input0_mjls{loop} = input_mjls;        
        time0{loop}= time;
        mse_reference_plot{loop}=mse_reference;
    elseif loop==2
        x30_wc=y_L;
        input0_wc = input;
        time0_wc= time;
        mse_reference_plot{loop}=mse_reference;
    end
    x1 = [];
    x2 = [];
    x3 = [];
    y_L = [];
    input = [];
    
    x1_mjls = [];
    x2_mjls = [];
    x3_mjls = [];
    y_L_mjls = [];
    input_mjls = [];
    mse_reference=[];
    
    time = [];
end

%% plot output
width = 10;     % Width in inches
height = 6;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 20;      % Fontsize
lw = 1;      % LineWidth
msz = 4;       % MarkerSize
figure('name','yL(m)')
pos = get(gcf, 'Position');
%set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
yticks([-0.04 -0.03 0 0.03 0.04]);
%for loop=1:num_plots
    marker_type=strcat('-',plot_markers(1));
    plot(time0{1}, x30{1},marker_type,'LineWidth',lw,'MarkerSize',msz,...
        'MarkerEdgeColor',plot_colours(1),...
         'Color', plot_colours(1))
    %    'MarkerIndices',1:10:length(time0{loop}),...
       
    hold on
    marker_type=strcat('-',plot_markers(2));
    plot(time0{1}, x30_mjls{1},marker_type,'LineWidth',lw,'MarkerSize',msz,...
       'MarkerEdgeColor',plot_colours(2),...
        'Color', plot_colours(2))
     %   'MarkerIndices',1:10:length(time0{loop}),...      
    hold on
    marker_type=strcat('-',plot_markers(3));
    plot(time0_wc, x30_wc,marker_type,'LineWidth',lw,'MarkerSize',msz,...
       'MarkerEdgeColor',plot_colours(3),...
        'Color', plot_colours(3))
     %   'MarkerIndices',1:10:length(time0{loop}),...      
    hold on
%end
plot(time_r, refer,'--', 'LineWidth',lw,'MarkerSize',msz,...
    'MarkerEdgeColor','c',...
    'Color', 'c')
ylabel('y_L (m)','FontSize',20) % x-axis label
xlabel('time (s)','FontSize',20) % y-axis label
legend({['SLC'],['MJLS'],'LQR','Reference'},'Location','southeast','FontSize',20)
set(gca,'YTick',[-0.04 -0.03 0 0.03 0.04]); 
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

% Save the file as PNG
%print_name=strcat('res_yL_',plot_colours(loop));
%print(print_name,'-dpng','-r300');
hold off
%% Plotting input
figure('name','input(rad)');
marker_type=strcat('-',plot_markers(1));
plot(time0{1}, input0{1}, marker_type,'LineWidth',lw,'MarkerSize',msz,...
    'MarkerEdgeColor', plot_colours(1),...
    'Color', plot_colours(1));
    %'MarkerIndices',1:20:length(time0),...   
hold on
marker_type=strcat('-',plot_markers(2));
plot(time0{1}, input0_mjls{1},marker_type,'LineWidth',lw,'MarkerSize',msz,...
    'MarkerEdgeColor', plot_colours(2),...
     'Color', plot_colours(2));
  %  'MarkerIndices',1:20:length(time0),...
hold on
marker_type=strcat('-',plot_markers(3));
plot(time0_wc, input0_wc, marker_type,'LineWidth',lw,'MarkerSize',msz,...
'MarkerEdgeColor', plot_colours(3),...
 'Color', plot_colours(3));
 
ylabel('u(t)') % x-axis label
xlabel('time (s)') % y-axis label
legend({['SLC'],['MJLS'],'LQR'},'Location','northeast','FontSize',20)
set(gcf,'InvertHardcopy','on');
set(gcf,'PaperUnits', 'inches');
%set(gca,'YTick',[-0.008 -0.004 0 0.004 0.008]); 
papersize = get(gcf, 'PaperSize');
left = (papersize(1)- width)/2;
bottom = (papersize(2)- height)/2;
myfiguresize = [left, bottom, width, height];
set(gcf,'PaperPosition', myfiguresize);

% Save the file as PNG
%print_name=strcat('res_u_',plot_colours(loop));
%print(print_name,'-dpng','-r300');
hold off

% figure('name','input power spectrum density');
% psd(input0{1});
% hold on
% psd(input0_mjls{1});
% hold on
% psd(input0_wc);
% legend({['SLC'],['MJLS'],'LQR'},'Location','southwest','FontSize',20) 
% hold off
if loop_ref==2
    S1 = stepinfo(x30{1},time0{1},ref(1),'SettlingTimeThreshold',0.05);
    st1 = S1.SettlingTime;
    S2 = stepinfo(x30_mjls{1},time0{1},ref(1),'SettlingTimeThreshold',0.05);
    st2 = S2.SettlingTime;
    S3 = stepinfo(x30_wc,time0_wc,ref(1),'SettlingTimeThreshold',0.05);
    st3 = S3.SettlingTime;
    figure('name', 'Settling Time')    
    bar([st1, st2, st3])
    set(gca,'XTickLabel',{'SLC','MJLS','LQR'})
end
figure('name', 'Mean Square Error')    
bar([immse(x30{1},mse_reference_plot{1}), immse(x30_mjls{1},mse_reference_plot{1}), immse(x30_wc,mse_reference_plot{2})])
set(gca,'XTickLabel',{'SLC','MJLS','LQR'})
figure('name', 'Control Effort')   
[maxSwitched, index]=max(abs(input0{1}));
[maxMJLS, index]=max(abs(input0_mjls{1}));
[maxWC, index]=max(abs(input0_wc));
bar([maxSwitched, maxMJLS, maxWC])
set(gca,'XTickLabel',{'SLC','MJLS','LQR'})
end
if run_cqlf==1
    if (all(eigenvalues < 1) == 1)
            display('Solution exists for Positive Definite Q matrix');
            display('Eigen value check (constraints) satisfied');
    else
            display('Solution exists for Positive Definite Q matrix');
            display('Eigen value check (constraints) NOT satisfied');
    end
end