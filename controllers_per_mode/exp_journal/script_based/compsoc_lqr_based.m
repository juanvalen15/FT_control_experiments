% function CompSOC_LPTV
% By Eelco van Horssen
% Adapted for Journal experiments by Juan Valencia

% function compsoc_lqr_based

%% SCRIPT CONFIGURATION
varsbefore = who; %// get names of current variables
% clearvars -global; clearvars; close all; clc;

format compact
format short

%% Include folders
addpath('lptv_tools');
addpath('plant');
addpath('timings');


%% LOAD SYSTEM EXAMPLE: CT model and timings set
timings_set;




%% configuration
tic

%% System dimensions and initial conditions
% dimensions
nx = size(Ac,2);
nu = size(Bc,2);

% Initial conditions
x1 = zeros(nx,1);
u0 = zeros(nu,1);


%% Simulation settings
LPTV_simulation_settings


%% Optimal CT solution
% Compute CT-LQR solution
[Kc,Pc,~] = lqr(Ac,Bc,Qc,Rc);


%% select sequence
si = 1;

% for si = 1:length(s) %Iterate for all sequences
display('---------------------------------')
s{:}
legendInfo{si} = ['Exp. ' num2str(si)];

N{si} = length(s{si}); % sequence length



%% Compute DT matrices  for each h_i (for augmented system)
%     [Ah,Bh,Qh,Sh,Rh] = deal([]);
[Ah,Bh,Qh,Rh] = deal([]);
for i = 1:length(all_h)
    %         [Ah{i},Bh{i},Qh{i},Sh{i},Rh{i}] = CTtoDTdelay(Ac,Bc,Qc,Rc,T,all_h(i));
    [Ah{i},Bh{i},Qh{i},Rh{i}] = CTtoDTdelay(Ac,Bc,Qc,Rc,T,all_h(i));
end

Qh{i}
Rh{i}




%% Compute the DT matrices according to the sequence
[As,Bs,Qs,Ss,Rs] = deal([]);
for p = 1:N{si}
    As{p} = Ah{s{si}(p)};
    Bs{p} = Bh{s{si}(p)};
    Qs{p} = Qh{s{si}(p)};
    %         Ss{p} = Sh{s{si}(p)};
    Rs{p} = Rh{s{si}(p)};
end







%% Compute matrices for whole period
Abar = [];
Au = [];
Bbartemp = [];
Bu = [];

nxi = size(Ah{1},1);

%Ap
Abar = eye(nxi);
for p = 1:N{si}-1
    Abar = [Abar ; MatMult(As,1,p)];
end

Abar;
Au = MatMult(As,1,N{si});




%Bp
Bbartemp = repmat(zeros(nxi,nu),1,N{si});
for p = 1:N{si} %rows
    Btemp = [];
    for q = 1:N{si} %columns
        if p < q %diagonal or above
            Btemp = [Btemp , zeros(nxi,nu)];
        else
            Btemp = [Btemp , MatMult(As,q+1,p)*Bs{q}];
        end
    end
    Bbartemp = [Bbartemp ; Btemp];
end
Bbar = Bbartemp(1:end-nxi,:);
Bu = Bbartemp(end-nxi+1:end,:);



%Cost
Qbar = blkdiag(Qs{1:N{si}});
%     Sbar = blkdiag(Ss{1:N{si}});
Rbar = blkdiag(Rs{1:N{si}});


Qtilde = Abar.'*Qbar*Abar;
%     Stilde = Abar.'*Sbar + Abar.'*Qbar*Bbar;
Rtilde = Rbar + Bbar.'*Qbar*Bbar;

% [Ptilde, ~, Ktilde] = dare(Au,Bu,Qtilde,Rtilde,Stilde);
[Ptilde, ~, Ktilde] = dare(Au,Bu,Qtilde,Rtilde);

testeigPbar = eig(Ptilde)


%% find gains
Ps = [];
Ks = [];
Gs = [];

Ps{N{si}+1} = Ptilde; % cost over whole period
for p = N{si}:-1:1
    Gs{p} = Rs{p} + Bs{p}.'*Ps{p+1}*Bs{p};
    Ks{p} = Gs{p}\(Bs{p}.'*Ps{p+1}*As{p});
    Ps{p} = As{p}.'*Ps{p+1}*As{p} + Qs{p} - (Bs{p}.'*Ps{p+1}*As{p}).'*inv(Rs{p} + Bs{p}.'*Ps{p+1}*Bs{p})*(Bs{p}.'*Ps{p+1}*As{p});
    % Ks{p} = Gs{p}\(Bs{p}.'*Ps{p+1}*As{p} + Ss{p}.');
    % Ps{p} = As{p}.'*Ps{p+1}*As{p} + Qs{p} - Ks{p}.'*Gs{p}*Ks{p}; % old Ps used in DATE
    % Ps{p} = As{p}.'*Ps{p+1}*As{p} + Qs{p} - (Bs{p}.'*Ps{p+1}*As{p} + Ss{p}.').'*inv(Rs{p} + Bs{p}.'*Ps{p+1}*Bs{p})*(Bs{p}.'*Ps{p+1}*As{p} + Ss{p}.');
end


P1 = Ps{1}; % cost at beginning



%check for Ktilde
CLprevtemp = eye(nxi); %xi0 = I*xi0;
Ktemp = Ks{1}*CLprevtemp; %K0 = Ks0*xi0
Kcheck = Ktemp;
for p = 2:N{si}
    CLprevtemp = (As{p-1} - Bs{p-1}*Ks{p-1})*CLprevtemp;
    Ktemp = Ks{p}*CLprevtemp;
    Kcheck = [Kcheck ; Ktemp];
end
Kchecks=Kcheck; %=equal to Ktilde?






%% Store results
save(['output/results/exp' num2str(EXP) '/LQR_LPTV/SysMatrices_set_' num2str(si) '.mat'],'As','Bs','Qs','Rs');
save(['output/results/exp' num2str(EXP) '/LQR_LPTV/ControlMatrices_set_' num2str(si) '.mat'],'Ks','Ps');

% end

elapsedTime = toc




%% CLEAR VARIABLES GENERATED IN THIS SCRIPT
varsafter = who; %// get names of all variables in 'varsbefore' plus variables
varsnew = setdiff(varsafter, varsbefore); %// variables  defined in the script
clear(varsnew{:})