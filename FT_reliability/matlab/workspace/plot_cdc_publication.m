clc;
clear all;
close all;
format short;

R=1; %For some cases switched system is unstable even though CQLF exists. Need to check more, why.
run_cqlf=0; %for faster simulation (run_cqlf=0), i.e you do not need to check for CQLF always. 
%to check for cqlf, run_cqlf==1
reference_profile=0.03;
%% # Markov States: can be 3,4 or 6
%To add more markov states edit the P_markov, period_s and Q_multiplier
no_markov_states=6;
%for 30 fps
%% DTMC transition matrix
if no_markov_states==3
P_markov = [0.5 0.25 0.25
            0.25 0.5 0.25
            0.25 0.25 0.5];
period_s=[1/30  2/30 3/30];
Q_multiplier=[0.02 0.006 0.001];

%% DTMC transition matrix   
elseif no_markov_states==4
P_markov = [    0.4706    0.0588    0.0882    0.3824
                0.1471    0.3235    0.2941    0.2353
                0.2647    0.2059    0.1765    0.3529
                0.1176    0.4118    0.4412    0.0294];
period_s=[2/60 3/60 4/60 6/60];
Q_multiplier=[0.02 0.006 0.006 0.001];

%% DTMC transition matrix  
elseif no_markov_states==6
P_markov =[     0.2732    0.1116    0.1145    0.1957    0.0407    0.2642
                0.3050    0.2885    0.0475    0.0195    0.1513    0.1882
                0.0078    0.0439    0.0082    0.2439    0.2950    0.4013
                0.2480    0.1481    0.2245    0.0485    0.1369    0.1939
                0.2708    0.2488    0.0580    0.1614    0.0137    0.2474
                0.2791    0.1095    0.0991    0.2611    0.1999    0.0513];
period_s=[1/60 2/60 3/60 4/60 5/60 6/60];
Q_multiplier=[0.02 0.02 0.006 0.006 0.001 0.001];
end
%% Pattern
timingPattern = [];
[~,Sys_wc]=max(period_s);
timingPattern_init = [1 2 Sys_wc;
                 Sys_wc Sys_wc Sys_wc];
% timingPattern_init = [3 3 3;
%                  2 2 2;
%                  1 1 1;
%                  2 3 1;
%                  1 2 3];

%% Plot settings
num_plots=1;
plot_colours=['r' 'b' 'k' 'g' 'm']; % 'y', 'c'
plot_markers=['o' 'p' 's' '*' '+'];
%for 30 fps

%% DSD gain computation
for i=1:length(period_s)
Ts = period_s(i);
delay = Ts*0.9;
% delay = Ts;
[phi_aug{i},Gamma_aug{i},Caug{i},K{i}, F{i}, A1{i}]=model_compute(Ts,delay,Q_multiplier(i),R);
end
%% CQLF LMI Yalmip: DSD
if run_cqlf==1
size_sys = size(A1{1});
Q=sdpvar(size_sys(1),size_sys(1));
L=[Q >= 0];
for i=1:length(period_s)
    L_temp=[[Q -Q*A1{i}'; -A1{i}*Q Q]>=0];
    L=L+L_temp;
end
ops=sdpsettings('solver','sedumi'); %mosek, sedumi, sdpt3
% ops=sdpsettings('verbose',1,'solver','sedumi','sedumi.eps',1e-12);
sol=optimize(L,[],ops); %Solving for P (matlab workspace)
Q=double(Q); 
eig(Q);
CQLF_stable=1;
if (sol.problem==0)
    [~,r] = chol(Q); %to check for positive definiteness. r==0 for + def
    if r==0 %all(eig(P)>eps) %check for Positive Definite
        display('Solution exists for Positive Definite Q matrix');
        eigenvalues = abs(eigs(A1{1}*A1{2}*A1{3}));
        %(A1{1}*A1{2}*A1{3})^100 should tend to zero for the system to be
        %stable
        if (all(eigenvalues < 1) == 1)
            %display('Solution exists for Positive Definite Q matrix');
            display('Eigen value check (constraints) satisfied');
        else
            %display('Solution exists for Positive Definite Q matrix');
            display('Eigen value check (constraints) NOT satisfied');
        end
    else
        display('Solution exists for Q, but it is not Positive Definite');        
        CQLF_stable=0;
        %return;
    end
else
    display('Hmm, something went wrong!');
    sol.info
    yalmiperror(sol.problem)
    return;
end
end

%% First, solve the coupled algebraic riccati equation (for IHOC) of the MJLS
clear X kappa
no_of_modes = length(period_s);
for mode = 1:no_of_modes
    size_sys = size(phi_aug{mode});
    X{mode} = sdpvar(size_sys(1));
    kappa{mode} = 0.5; %stationary distribution%Q_multiplier(mode)
end
con = [];

for mode = 1:no_of_modes
  %  E{mode} = P_markov(mode,1)*X{1} +  P_markov(mode,2)*X{2} +  P_markov(mode,3)*X{3};
  %ORIGINAL code below
  %tmpIn1 =  [-X{mode}+phi_aug{mode}'*(P_markov(mode,1)*X{1} +  P_markov(mode,2)*X{2} +  P_markov(mode,3)*X{3})*phi_aug{mode}+kappa{mode}*Q_multiplier(mode)*Caug{mode}'*Caug{mode}, phi_aug{mode}'*(P_markov(mode,1)*X{1} +  P_markov(mode,2)*X{2} +  P_markov(mode,3)*X{3})*Gamma_aug{mode}
  %Gamma_aug{mode}'*(P_markov(mode,1)*X{1} +  P_markov(mode,2)*X{2} +  P_markov(mode,3)*X{3})*phi_aug{mode}, Gamma_aug{mode}'*(P_markov(mode,1)*X{1} +  P_markov(mode,2)*X{2} +  P_markov(mode,3)*X{3})*Gamma_aug{mode}+kappa{mode}*R];
  %tmpIn2 = Gamma_aug{mode}'*(P_markov(mode,1)*X{1} +  P_markov(mode,2)*X{2} +  P_markov(mode,3)*X{3})*Gamma_aug{mode}+kappa{mode}*R;  
  %BEGIN:edit for multiple loops%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  add_P_markov=zeros(size_sys(1),size_sys(2));
  for i=1:no_of_modes
      add_P_markov=add_P_markov+P_markov(mode,i)*X{i};
  end
  tmpIn1 =  [-X{mode}+ phi_aug{mode}'*(add_P_markov)*phi_aug{mode}+kappa{mode}*Q_multiplier(mode)*Caug{mode}'*Caug{mode}, phi_aug{mode}'*(add_P_markov)*Gamma_aug{mode}
  Gamma_aug{mode}'*(add_P_markov)*phi_aug{mode}, Gamma_aug{mode}'*(add_P_markov)*Gamma_aug{mode}+kappa{mode}*R];
  tmpIn2 = Gamma_aug{mode}'*(add_P_markov)*Gamma_aug{mode}+kappa{mode}*R;  
  %END:edit for multiple loops%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  con = con + [tmpIn1 >= 0] + [tmpIn2 > 0];% + [kappa{mode} > 0
end
%original code below
% con = con + [X{1} > 0] + [X{2} > 0] + [X{3} > 0]
% obj = trace(X{1} + X{2} + X{3})%-(trace(X{1}) + trace(X{2}) + trace(X{3}))
%BEGIN:edit for multiple loops%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
obj=0;
for mode = 1:no_of_modes
con = con + [X{mode} > 0];
obj = obj + trace(X{mode});
end
%END:edit for multiple loops%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
optimize(con, -obj)

% %Now obtain the gains
%BEGIN:edit for multiple loops%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% JUAN: add_P_markov_value = expected value of X

for mode = 1:no_of_modes
     add_P_markov_value=zeros(size_sys(1),size_sys(2));
     for i=1:no_of_modes
         add_P_markov_value = add_P_markov_value + P_markov(mode,i)*value(X{i});
     end
     K_gain{mode} = -inv(R + Gamma_aug{mode}'*(add_P_markov_value)*Gamma_aug{mode})*Gamma_aug{mode}'*(add_P_markov_value)*phi_aug{mode};
     Forward_gain{mode} = 1/(Caug{mode}*inv(eye(size(phi_aug{mode}))-(phi_aug{mode}-Gamma_aug{mode}*K_gain{mode}))*Gamma_aug{mode});
 end
%END:edit for multiple loops%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  for mode = 1:no_of_modes
%      F_gain{mode} = -inv(R + Gamma_aug{mode}'*(P_markov(mode,1)*value(X{1}) +  P_markov(mode,2)*value(X{2}) +  P_markov(mode,3)*value(X{3}))*Gamma_aug{mode})*Gamma_aug{mode}'*(P_markov(mode,1)*value(X{1}) +  P_markov(mode,2)*value(X{2}) +  P_markov(mode,3)*value(X{3}))*phi_aug{mode};
%      Forward_gain{mode} = 1/(Caug{mode}*inv(eye(5,5)-(phi_aug{mode}-Gamma_aug{mode}*F_gain{mode}))*Gamma_aug{mode});
%  end

%% Simulation
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
                y_L(i+1) = Caug{Sys}*[x1(i);x2(i);x3(i);x4(i);input(i)];
                
                x1_mjls(i+1) = x1_mjls(i);
                x2_mjls(i+1) = x2_mjls(i);
                x3_mjls(i+1) = x3_mjls(i);
                x4_mjls(i+1) = x4_mjls(i);
                input_mjls(i+1) = input_mjls(i);
                y_L_mjls(i+1) = Caug{Sys}*[x1_mjls(i);x2_mjls(i);x3_mjls(i);x4_mjls(i);input_mjls(i)];
                              
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
                U = K{Sys}*[x1(i);x2(i);x3(i);x4(i);0];
                xkp1 = phi_aug{Sys}*[x1(i);x2(i);x3(i);x4(i);0] + Gamma_aug{Sys}*U;
                
                U_mjls = K_gain{Sys}*[x1_mjls(i);x2_mjls(i);x3_mjls(i);x4_mjls(i);0];
                xkp1_mjls = phi_aug{Sys}*[x1_mjls(i);x2_mjls(i);x3_mjls(i);x4_mjls(i);0] + Gamma_aug{Sys}*U_mjls;
            else
                U = K{Sys}*[x1(i);x2(i);x3(i);x4(i);input(i-1)] + F{Sys}*r;
                xkp1 = phi_aug{Sys}*[x1(i);x2(i);x3(i);x4(i);input(i-1)] + Gamma_aug{Sys}*U;
                
                U_mjls = K_gain{Sys}*[x1_mjls(i);x2_mjls(i);x3_mjls(i);x4_mjls(i);input_mjls(i-1)] - Forward_gain{Sys}*r;
                xkp1_mjls = phi_aug{Sys}*[x1_mjls(i);x2_mjls(i);x3_mjls(i);x4_mjls(i);input_mjls(i-1)] + Gamma_aug{Sys}*U_mjls;
            end
            
            x1_mjls(i+1) = xkp1_mjls(1);
            x2_mjls(i+1) = xkp1_mjls(2);
            x3_mjls(i+1) = xkp1_mjls(3);
            x4_mjls(i+1) = xkp1_mjls(4);
            input_mjls(i+1) = U_mjls;
            y_L_mjls(i+1) = Caug{Sys}*xkp1_mjls;
            
            x1(i+1) = xkp1(1);
            x2(i+1) = xkp1(2);
            x3(i+1) = xkp1(3);
            x4(i+1) = xkp1(4);
            input(i+1) = U;
            y_L(i+1) = Caug{Sys}*xkp1;

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
    x4 = [];
    y_L = [];
    input = [];
    
    x1_mjls = [];
    x2_mjls = [];
    x3_mjls = [];
    x4_mjls = [];
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