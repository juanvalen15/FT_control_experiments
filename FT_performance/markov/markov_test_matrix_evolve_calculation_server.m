%% Markov process model of Fault-Tolerant Switching Mechanism
%% clear all
clear all;
close all;
clc;

%%
n = 3;

f = [4 1 1];    
    

exp = 0;
for Ps = 0.1:0.1:0.9
    exp = exp + 1;
    % Ps = 0.8;
    for i = 1:3
        Pfm(i)  = Ps^(2^(i+1)); % prob. of not being operational in mode mi
    end
    
    
    %% transition matrix
    m11 = 1-Pfm(1);
    m12 = Pfm(1);
    m13 = 0;
    m14 = 0;
    m15 = 0;
    m16 = 0;
    m17 = 0;
    m18 = 0;
    
    m21 = 0;
    m22 = 1-Pfm(2)-(1-Pfm(2))^f(2);
    m23 = Pfm(2);
    m24 = 0;
    m25 = (1-Pfm(2))^f(2);
    m26 = 0;
    m27 = 0;
    m28 = 0;
    
    m31 = 0;
    m32 = 0;
    m33 = 1 - Pfm(3)^f(3) - (1-Pfm(3))^f(3);
    m34 = (1-Pfm(3))^f(3);
    m35 = 0;
    m36 = 0;
    m37 = 0;
    m38 = Pfm(3)^f(3);
    
    m41 = 0;
    m42 = 0;
    m43 = 0;
    m44 = 1 - Pfm(2)^f(2) - (1-Pfm(2))^f(2);
    m45 = (1-Pfm(2))^f(2);
    m46 = 0;
    m47 = 0;
    m48 = Pfm(2)^f(2);
    
    m51 = 0;
    m52 = 0;
    m53 = Pfm(2);
    m54 = 0;
    m55 = 0;
    m56 = 1-Pfm(2);
    m57 = 0;
    m58 = 0;
    
    m61 = 0;
    m62 = 0;
    m63 = 0;
    m64 = 0;
    m65 = 0;
    m66 = 1 - Pfm(1)^f(1) - (1-Pfm(1))^f(1);
    m67 = (1-Pfm(1))^f(1);
    m68 = Pfm(1)^f(1);
    
    m71 = 0;
    m72 = 0;
    m73 = 0;
    m74 = Pfm(1);
    m75 = 0;
    m76 = 1-Pfm(1);
    m77 = 0;
    m78 = 0;
    
    m81 = 0;
    m82 = 0;
    m83 = 0;
    m84 = 0;
    m85 = 0;
    m86 = 0;
    m87 = 0;
    m88 = 1;
    
    
    M = [m11 m12 m13 m14 m15 m16 m17 m18; ...
        m21 m22 m23 m24 m25 m26 m27 m28; ...
        m31 m32 m33 m34 m35 m36 m37 m38; ...
        m41 m42 m43 m44 m45 m46 m47 m48; ...
        m51 m52 m53 m54 m55 m56 m57 m58; ...
        m61 m62 m63 m64 m65 m66 m67 m78; ...
        m71 m72 m73 m74 m75 m76 m77 m78; ...
        m81 m82 m83 m84 m85 m86 m87 m88];
    
    
    
    
    
    %% iterations test
    LOOPS = 1000000;
    
    state(1,:) = [1 0 0 0 0 0 0 0]; % initialization in mode 1
    for i = 2:LOOPS
        state(i,:) = state(i-1,:) * M;
    end
    
    %% settling time: estimatio of the probability of being reliable
    temp_reliability = 1-state(:,8);
    info_temp        = stepinfo(temp_reliability);
    
    if ceil(info_temp.SettlingTime) == 0
        settling_temp    = ceil(info_temp.SettlingTime);
    else
        settling_temp    = ceil(info_temp.SettlingTime);
    end
    
    reliailibty_temp = temp_reliability(settling_temp)
    
    reliability(exp) = reliailibty_temp;
    
end




%%

figure;
plot(reliability, '-o');
ylabel('Reliability [probability of being operational]');
xlabel('Ps [probability of fault at application slot]');

labels = 0.1:0.1:0.9;
set(gca, 'XTick', 1:length(labels)); % Change x-axis ticks
set(gca, 'XTickLabel', labels); % Change x-axis ticks labels.

grid on;
grid minor;


%% markov chain - visualization
% mc = dtmc(M, 'StateNames', ["m1I" "m2I" "m3" "m2S" "SWm2S" "m1S" "SWm1S" "instability"]);
%
% figure;
% graphplot(mc,'ColorEdges',true);
%
% rng(1); % For reproducibility
% numSteps = 2000;
% X0 = [1; 0; 0; 0; 0; 0; 0; 0]; % initial state
% X0(1) = 10; % 100 random walks starting from state 1 only
% X = simulate(mc,numSteps,'X0',X0);
%
% figure;
% simplot(mc,X,'Type','transitions');









