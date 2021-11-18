% FT control design for performance and reliability tradefofffs.
% mainFT.m

close all;
clear all;
clc;

%% configuration
no_markov_states  = 2;
reference_profile = 0.03;
R                 = 1;


%% DTMC transition matrix
if no_markov_states==2
    P_markov = [0.5 0.25
                0.25 0.5];
    period_s=[0.03 0.06];
    Q_multiplier=[1 1];
end


%% Pattern
timingPattern = [];
[~,Sys_wc] = max(period_s);
timingPattern_init = [1 2 Sys_wc; Sys_wc Sys_wc Sys_wc]; 
                  
%% Gains computation
for i=1:length(period_s)
Ts    = period_s(i);
delay = Ts*0.9;
[phi_aug{i},Gamma_aug{i},C_aug{i},K{i},F{i}] = model_compute(Ts,delay,Q_multiplier(i),R);
end                  
                  
%% First, solve the coupled algebraic riccati equation (for IHOC) of the MJLS
no_of_modes = length(period_s);

for mode = 1:no_of_modes
    size_sys = size(phi_aug{mode});
    X{mode} = sdpvar(size_sys(1));
    kappa{mode} = 0.5; %stationary distribution % Q_multiplier(mode)
end

con = [];
for mode = 1:no_of_modes
  %  E{mode} = P_markov(mode,1)*X{1} +  P_markov(mode,2)*X{2} +  P_markov(mode,3)*X{3};
  add_P_markov = zeros(size_sys(1),size_sys(2));
  
  for i=1:no_of_modes
      add_P_markov = add_P_markov + P_markov(mode,i)*X{i};
  end
  
  tmpIn1 =  [-X{mode} + phi_aug{mode}'*(add_P_markov)*phi_aug{mode} + kappa{mode}*Q_multiplier(mode)*C_aug{mode}'*C_aug{mode}, phi_aug{mode}'*(add_P_markov)*Gamma_aug{mode}
             Gamma_aug{mode}'*(add_P_markov)*phi_aug{mode}, Gamma_aug{mode}'*(add_P_markov)*Gamma_aug{mode}+kappa{mode}*R];
  tmpIn2 = Gamma_aug{mode}'*(add_P_markov)*Gamma_aug{mode}+kappa{mode}*R;  

  con = con + [tmpIn1 >= 0] + [tmpIn2 >= 0] % + [kappa{mode} > 0] % equal for non strict lmi
end

%original code below
% con = con + [X{1} > 0] + [X{2} > 0] + [X{3} > 0]
% obj = trace(X{1} + X{2} + X{3})%-(trace(X{1}) + trace(X{2}) + trace(X{3}))
%BEGIN:edit for multiple loops%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
obj=0;
for mode = 1:no_of_modes
    con = con + [X{mode} >= 0]; % equal for non strict lmi
    obj = obj + trace(X{mode});
end
%END:edit for multiple loops%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
optimize(con, -obj)

% Now obtain the gains
%BEGIN:edit for multiple loops%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% JUAN: add_P_markov_value = expected value of X
for mode = 1:no_of_modes
     add_P_markov_value=zeros(size_sys(1),size_sys(2));
     for i=1:no_of_modes
         add_P_markov_value = add_P_markov_value + P_markov(mode,i)*value(X{i});
     end
     K_gain{mode} = -inv(R + Gamma_aug{mode}'*(add_P_markov_value)*Gamma_aug{mode})*Gamma_aug{mode}'*(add_P_markov_value)*phi_aug{mode};
     Forward_gain{mode} = 1/(C_aug{mode}*inv(eye(size(phi_aug{mode}))-(phi_aug{mode}-Gamma_aug{mode}*K_gain{mode}))*Gamma_aug{mode});
 end
%END:edit for multiple loops%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  for mode = 1:no_of_modes
%      F_gain{mode} = -inv(R + Gamma_aug{mode}'*(P_markov(mode,1)*value(X{1}) +  P_markov(mode,2)*value(X{2}) +  P_markov(mode,3)*value(X{3}))*Gamma_aug{mode})*Gamma_aug{mode}'*(P_markov(mode,1)*value(X{1}) +  P_markov(mode,2)*value(X{2}) +  P_markov(mode,3)*value(X{3}))*phi_aug{mode};
%      Forward_gain{mode} = 1/(C_aug{mode}*inv(eye(5,5)-(phi_aug{mode}-Gamma_aug{mode}*F_gain{mode}))*Gamma_aug{mode});
%  end


% call simulation script
simulation;
